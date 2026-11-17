#!/usr/bin/env python3
"""Fail closed on private paths or obvious personal identifiers/secrets."""
import argparse
import io
from pathlib import Path, PurePosixPath
import re
import subprocess
import zipfile

ROOT = Path(__file__).resolve().parents[1]
TEXT = {'.r', '.rmd', '.md', '.html', '.css', '.js', '.json', '.csv', '.txt',
        '.bib', '.xml', '.yml', '.yaml', '.dcf', '.rproj', '.svg'}
ARCHIVES = {'.zip', '.docx', '.pptx'}
PRIVATE_PARTS = {'submissions', 'feedback-preparation', 'final-assessment',
                 'formative-assessment', 'student-feedback', 'feedbacksheets',
                 'answers', 'rsconnect', '.git', '.aws', '.agents', '.codex', '.rproj.user'}
PATTERNS = {
    'student-number pattern': re.compile(rb'\bN\d{7}\b'),
    'GitHub access token': re.compile(rb'\bgh[pousr]_[A-Za-z0-9]{30,}\b'),
    'AWS access key': re.compile(rb'\bAKIA[A-Z0-9]{16}\b'),
    'private key': re.compile(rb'-----BEGIN (?:RSA |OPENSSH |EC )?PRIVATE KEY-----'),
}


def check_path(name, allow_publish_metadata=False):
    name = str(name).replace('\\', '/')
    p = PurePosixPath(name)
    if p.is_absolute() or '..' in p.parts:
        raise ValueError('Unsafe publication/archive path')
    if p.as_posix().lower() == '2026/admin/moved-files.csv':
        raise ValueError('Private file-move inventory is not publishable')
    parts = {part.lower() for part in p.parts}
    blocked = PRIVATE_PARTS - ({'rsconnect'} if allow_publish_metadata else set())
    if parts & blocked or ('2025' in parts and 'ml' in parts):
        raise ValueError('Private path is not publishable')
    for part in parts:
        if part.startswith(('classlist', '.env', 'rpubs-records-')) or re.match(r'\d{6}-\d{6}\b', part):
            raise ValueError('Private record/credential path is not publishable')
        if 'student' in part and ('suggestion' in part or 'message' in part):
            raise ValueError('Private student communication is not publishable')
    return p


def scan_payload(data, name, depth=0, allow_publish_metadata=False):
    """Inspect archive member names and text, without printing matching values."""
    check_path(name, allow_publish_metadata)
    suffix = Path(name).suffix.lower()
    count = 0
    if suffix in ARCHIVES:
        if depth > 2:
            raise ValueError('Nested archive exceeds publication audit depth')
        with zipfile.ZipFile(io.BytesIO(data)) as archive:
            total = 0
            for item in archive.infolist():
                check_path(item.filename, allow_publish_metadata)
                # ZIP Unix attributes can encode symlinks.
                if (item.external_attr >> 16) & 0o170000 == 0o120000:
                    raise ValueError('Archive contains a symlink')
                total += item.file_size
                if item.file_size > 200_000_000 or total > 500_000_000:
                    raise ValueError('Archive exceeds publication audit size limit')
                if Path(item.filename).suffix.lower() in TEXT | ARCHIVES:
                    count += scan_payload(archive.read(item), item.filename, depth + 1, allow_publish_metadata)
        return count
    if suffix in TEXT or Path(name).name in {'.Rprofile', '.gitignore'}:
        for label, pattern in PATTERNS.items():
            if pattern.search(data):
                raise ValueError(f'{label} found; remove it from the public material')
        count += 1
    return count


def audit_git(history=False):
    tracked = subprocess.check_output(['git', 'ls-files', '-z'], cwd=ROOT).decode().split('\0')
    checked = 0
    for name in filter(None, tracked):
        check_path(name)
        path = ROOT / name
        if path.is_file():
            try:
                checked += scan_payload(path.read_bytes(), name)
            except ValueError as exc:
                raise ValueError(f'Public-file audit failed: {name}: {exc}') from exc
    historical = 0
    if history:
        refs = subprocess.check_output(['git', 'rev-list', '--objects', '--all'], cwd=ROOT, text=True)
        blobs = {}
        for line in refs.splitlines():
            oid, _, name = line.partition(' ')
            if name:
                check_path(name, allow_publish_metadata=True)
                if Path(name).suffix.lower() in TEXT | ARCHIVES or Path(name).name in {'.Rprofile', '.gitignore'}:
                    blobs.setdefault(oid, name)
        for oid, name in blobs.items():
            kind = subprocess.check_output(['git', 'cat-file', '-t', oid], cwd=ROOT, text=True).strip()
            if kind == 'blob':
                data = subprocess.check_output(['git', 'cat-file', 'blob', oid], cwd=ROOT)
                try:
                    historical += scan_payload(data, name, allow_publish_metadata=True)
                except ValueError as exc:
                    raise ValueError(f'History audit failed: {name}: {exc}') from exc
    return checked, historical


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--history', action='store_true')
    args = parser.parse_args()
    current, past = audit_git(args.history)
    print(f'Public repository audit passed: {current} current text/archive members; {past} historical.')
