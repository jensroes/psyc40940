#!/usr/bin/env python3
"""Add self-contained clickable controls to ioslides, preserving keyboard navigation."""
import argparse
import json
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
TEMPLATE = Path(__file__).with_name('slide-navigation.html')
BLOCK = re.compile(r'<!-- course-slide-navigation:start -->.*?<!-- course-slide-navigation:end -->', re.S)


def with_navigation(html):
    if not re.search(r'<slides\b', html, re.I):
        return html
    html = BLOCK.sub('', html)
    return re.sub(r'\s*</body>', lambda _: '\n' + TEMPLATE.read_text() + '\n</body>', html, count=1, flags=re.I)


def add_navigation(path):
    path = Path(path)
    original = path.read_text()
    updated = with_navigation(original)
    if updated != original:
        path.write_text(updated)
        return True
    return False


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('files', nargs='*', type=Path)
    args = parser.parse_args()
    files = args.files
    if not files:
        manifest = json.loads((ROOT / 'publishing/site_manifest.json').read_text())
        files = [ROOT / f['source'] for session in manifest['sessions'] for f in session['files'] if f['source'].endswith('.html')]
        files += [ROOT / f['source'] for f in manifest['archive_2025']]
    changed = sum(add_navigation(path) for path in files)
    print(f'Updated navigation in {changed} slide decks.')
