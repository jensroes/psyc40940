#!/usr/bin/env python3
"""Build the selected public materials and publish them to the gh-pages branch."""
import shutil
import subprocess
import tempfile
from pathlib import Path

from audit_publication import ROOT, audit_git
from build_site import build

REPOSITORY = 'https://github.com/jensroes/psyc40940.git'


def git(*args, cwd=ROOT):
    return subprocess.check_output(['git', *args], cwd=cwd, text=True).strip()


def publish():
    audit_git(history=True)
    site = build()
    remote = git('ls-remote', '--heads', REPOSITORY, 'refs/heads/gh-pages')
    with tempfile.TemporaryDirectory(prefix='psyc40940-pages-') as temporary:
        release = Path(temporary) / 'release'
        if remote:
            git('clone', '--single-branch', '--branch', 'gh-pages', REPOSITORY, str(release))
            # This branch holds generated site files only. Preserve its Git history.
            for path in release.iterdir():
                if path.name == '.git':
                    continue
                if path.is_dir() and not path.is_symlink():
                    shutil.rmtree(path)
                else:
                    path.unlink()
        else:
            release.mkdir()
            git('init', '--initial-branch=gh-pages', str(release))
            git('remote', 'add', 'origin', REPOSITORY, cwd=release)
        git('config', 'user.name', git('config', 'user.name'), cwd=release)
        git('config', 'user.email', git('config', 'user.email'), cwd=release)
        for path in site.iterdir():
            if path.name == '.teaching-site-output':
                continue
            if path.is_dir():
                shutil.copytree(path, release / path.name)
            else:
                shutil.copy2(path, release / path.name)
        git('add', '--all', cwd=release)
        if git('status', '--porcelain', cwd=release):
            git('commit', '-m', 'Publish updated PSYC40940 teaching materials', cwd=release)
            git('push', 'origin', 'gh-pages', cwd=release)
        else:
            print('The published teaching files are already up to date.')
    print('Published site: https://jensroes.github.io/psyc40940/')


if __name__ == '__main__':
    publish()
