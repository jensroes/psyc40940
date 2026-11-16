#!/usr/bin/env python3
"""Publish only the rendered teaching files explicitly listed in the manifest."""
import argparse
from html import escape
from html.parser import HTMLParser
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
from urllib.parse import unquote, urlsplit

from audit_publication import ROOT, check_path, scan_payload

MANIFEST = Path(__file__).with_name('site_manifest.json')


class References(HTMLParser):
    def __init__(self):
        super().__init__()
        self.urls = []

    def handle_starttag(self, tag, attrs):
        for key, value in attrs:
            if key in {'href', 'src', 'poster'} and value:
                self.urls.append(value)


def source_path(root, name):
    check_path(name)
    path = root / name
    if path.is_symlink() or any(p.is_symlink() for p in path.parents if p != root.parent):
        raise ValueError('Symlinks cannot enter the publication')
    resolved = path.resolve()
    if not resolved.is_relative_to(root.resolve()) or not resolved.is_file():
        raise ValueError(f'Missing/unsafe selected teaching file: {name}')
    return resolved


def manifest_files(manifest):
    result = []
    for unit in manifest['sessions']:
        result.extend(file['source'] for file in unit['files'])
    result.extend(file['source'] for file in manifest['guides'])
    result.extend(file['source'] for file in manifest['archive_2025'])
    if len(result) != len(set(result)):
        raise ValueError('Duplicate source in publication manifest')
    return result


def relative_href(source, page):
    return Path(os.path.relpath(source, Path(page).parent)).as_posix()


def document(title, body, page='index.html'):
    css = relative_href('site.css', page)
    home = relative_href('index.html', page)
    archive = relative_href('2025/index.html', page)
    return f'''<!doctype html>
<html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>{escape(title)} · PSYC40940</title><link rel="stylesheet" href="{css}"></head>
<body><a class="skip" href="#content">Skip to content</a><header><div class="wrap">
<a class="brand" href="{home}">PSYC40940</a><nav aria-label="Course navigation"><a href="{home}">2026 materials</a><a href="{archive}">2025 archive</a></nav>
</div></header><main id="content" class="wrap">{body}</main><footer class="wrap">Jens Roeser · Visualisation of Behavioural Data and Data Dashboards</footer></body></html>'''


def index_page(manifest, page='index.html'):
    cards = []
    for unit in manifest['sessions']:
        links = ''.join(f'<a class="resource" href="{escape(relative_href(f["source"], page))}">{escape(f["label"])}</a>' for f in unit['files'])
        cards.append(f'<section class="session" id="week-{unit["week"]}"><p class="eyebrow">Week {unit["week"]}</p><h2>{escape(unit["title"])}</h2><div class="resources">{links}</div></section>')
    guides = ''.join(f'<li><a href="{escape(relative_href(g["source"], page))}">{escape(g["label"])}</a></li>' for g in manifest['guides'])
    body = f'''<p class="eyebrow">2026 teaching materials</p><h1>Visualisation of Behavioural Data<br>and Data Dashboards</h1>
<p class="intro">Slides, session guides and practical exercises for PSYC40940. Open the slides and guides in your browser; download the exercises for RStudio.</p>
<p>Use NOW for announcements, assessment submission and individual feedback.</p>
<div class="sessions">{''.join(cards)}</div><section class="assessment"><h2>Preparing an assessment submission</h2><p>Read these guides alongside the current assessment brief and AI declaration form on NOW.</p><ul>{guides}</ul></section>'''
    return document('2026 teaching materials', body, page)


CSS = '''*{box-sizing:border-box}body{margin:0;color:#203137;background:#f6f8f8;font:17px/1.6 system-ui,-apple-system,BlinkMacSystemFont,"Segoe UI",sans-serif}.wrap{max-width:1120px;margin:auto;padding:24px}header{background:#153e45;color:white}header .wrap{display:flex;align-items:center;justify-content:space-between;gap:24px;padding-block:18px}header a{color:white}.brand{font-weight:750;text-decoration:none;letter-spacing:.06em}nav{display:flex;gap:24px}a{color:#115d69;text-underline-offset:3px}a:focus-visible{outline:3px solid #e4a938;outline-offset:5px}h1{font-size:clamp(2rem,5vw,3.3rem);line-height:1.15;letter-spacing:-.035em;max-width:1000px}h2{font-size:1.28rem;line-height:1.35;margin:.3em 0 1em}.intro{max-width:760px;font-size:1.15rem}.eyebrow{font-size:.8rem;text-transform:uppercase;letter-spacing:.1em;font-weight:750;color:#526970;margin:1em 0 .3em}.sessions{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:20px;margin-block:36px}.session{background:white;border:1px solid #d3dfe0;border-radius:9px;padding:24px}.resources{display:flex;flex-wrap:wrap;gap:10px}.resource{padding:7px 12px;border:1px solid #bbd0d3;border-radius:5px;text-decoration:none;font-size:.93rem}.resource:hover{background:#e8f2f2}.assessment{padding:25px;background:#e9f1ef;border-radius:9px;margin:30px 0}footer{font-size:.85rem;color:#526970;border-top:1px solid #d3dfe0}.skip{position:absolute;top:-100px;left:12px;background:white;padding:12px}.skip:focus{top:0}.archive-list li{margin-bottom:12px}@media(max-width:650px){.sessions{grid-template-columns:1fr}.wrap{padding:18px}header .wrap{align-items:flex-start;flex-direction:column;gap:8px}nav{gap:18px}h1 br{display:none}}
'''


def validate_links(output):
    for path in output.rglob('*.html'):
        parser = References()
        parser.feed(path.read_text(errors='replace'))
        for url in parser.urls:
            bits = urlsplit(url)
            if bits.scheme or bits.netloc or not bits.path:
                continue
            target = (path.parent / unquote(bits.path)).resolve()
            if not target.is_relative_to(output.resolve()) or not target.exists():
                raise ValueError(f'Broken/unsafe local link in {path.relative_to(output)}: {bits.path}')


def build(root=ROOT, output=None, manifest=None):
    root = Path(root).resolve()
    manifest = manifest or json.loads(MANIFEST.read_text())
    output = Path(output or root / '_site').resolve()
    if output == root or root.is_relative_to(output):
        raise ValueError('Output cannot contain or replace the source repository')
    if output.exists():
        if not (output / '.teaching-site-output').exists():
            raise ValueError('Refusing to replace a folder not created by this builder')
        shutil.rmtree(output)
    output.mkdir(parents=True)
    (output / '.teaching-site-output').write_text('Generated teaching-site output\n')
    allowed = set(manifest_files(manifest))
    pending = list(allowed)
    copied = set()
    while pending:
        name = pending.pop()
        if name in copied:
            continue
        source = source_path(root, name)
        data = source.read_bytes()
        scan_payload(data, name)
        destination = output / name
        destination.parent.mkdir(parents=True, exist_ok=True)
        destination.write_bytes(data)
        copied.add(name)
        if source.suffix.lower() == '.html':
            parser = References()
            parser.feed(data.decode(errors='replace'))
            styles = re.findall(r'<style[^>]*>(.*?)</style>', data.decode(errors='replace'), re.S | re.I)
            urls = parser.urls + [url for style in styles for url in re.findall(r'url\([\'\"]?([^\)\'\"]+)', style)]
            for url in urls:
                bits = urlsplit(url)
                if bits.scheme or bits.netloc or not bits.path:
                    continue
                linked_path = source.parent / unquote(bits.path)
                if linked_path.is_symlink() or any(p.is_symlink() for p in linked_path.parents):
                    raise ValueError('HTML asset links cannot use symlinks')
                candidate = linked_path.resolve()
                if not candidate.is_relative_to(root):
                    raise ValueError('HTML links outside the repository')
                dependency = candidate.relative_to(root).as_posix()
                check_path(dependency)
                # Another document/download must itself be selected. Only assets may be inferred.
                if dependency not in allowed and candidate.suffix.lower() not in {'.png','.jpg','.jpeg','.gif','.svg','.webp','.css','.js','.woff','.woff2','.ttf'}:
                    raise ValueError(f'Unselected document linked from {name}: {dependency}')
                if dependency not in copied:
                    pending.append(dependency)
    (output / 'site.css').write_text(CSS)
    (output / 'index.html').write_text(index_page(manifest))
    (output / '2026').mkdir(exist_ok=True)
    (output / '2026/index.html').write_text(index_page(manifest, '2026/index.html'))
    archive_links = ''.join(f'<li><a href="{escape(relative_href(p["source"], "2025/index.html"))}">{escape(p["title"])}</a></li>' for p in manifest['archive_2025'])
    archive_body = '<p class="eyebrow">Historical materials</p><h1>2025 slide archive</h1><p>These slides are retained from the previous teaching year. Use the 2026 materials and current NOW assessment brief for the current module.</p><ul class="archive-list">'+archive_links+'</ul>'
    (output / '2025').mkdir(exist_ok=True)
    (output / '2025/index.html').write_text(document('2025 archive', archive_body, '2025/index.html'))
    (output / '404.html').write_text(document('Page not found', '<h1>Page not found</h1><p>Use the course navigation to find the current slides and guides.</p>'))
    (output / '.nojekyll').touch()
    inventory = [{'path':p.relative_to(output).as_posix(),'sha256':hashlib.sha256(p.read_bytes()).hexdigest()} for p in sorted(output.rglob('*')) if p.is_file() and not p.name.startswith('.')]
    (output / 'publication-manifest.json').write_text(json.dumps(inventory,indent=2)+'\n')
    validate_links(output)
    size = sum(p.stat().st_size for p in output.rglob('*') if p.is_file())
    print(f'Built {len(copied)} selected teaching files/dependencies; {size / 1048576:.1f} MiB. Local links and publication checks passed.')
    return output


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path)
    args = parser.parse_args()
    build(output=args.output)
