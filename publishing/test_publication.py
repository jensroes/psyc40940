"""Exercise the boundaries that keep private coursework out of the public site."""
import io
import json
from pathlib import Path
import tempfile
import unittest
import zipfile

from audit_publication import check_path, scan_payload
from build_site import build


class PublicationTests(unittest.TestCase):
    def test_private_paths_are_rejected(self):
        for path in ('2026/formative-assessment/report.html', 'answers/app.R',
                     'student-feedback/report.pdf', 'submissions/report.zip',
                     '../private.txt', '/private.txt', 'folder\\..\\private.txt',
                     'classlist.csv', '.env.production', 'student suggestions messages.md',
                     '2026/admin/moved-files.csv', 'archive/rpubs-records-old/Document.dcf'):
            with self.subTest(path=path), self.assertRaises(ValueError):
                check_path(path)

    def test_archives_are_inspected(self):
        for name, content in [('answers/app.R', 'print(1)'), ('report.md', 'N' + '1234567'),
                              ('../report.md', 'text')]:
            data = io.BytesIO()
            with zipfile.ZipFile(data, 'w') as archive:
                archive.writestr(name, content)
            with self.subTest(name=name), self.assertRaises(ValueError):
                scan_payload(data.getvalue(), 'exercises.zip')

    def test_obvious_credentials_are_rejected(self):
        with self.assertRaises(ValueError):
            scan_payload(('ghp_' + 'a' * 36).encode(), 'notes.md')

    def fixture(self, root, html='<p>Public slides</p>'):
        (root / 'slides.html').write_text(html)
        return {'sessions': [{'week': 1, 'title': 'Introduction', 'files': [
            {'source': 'slides.html', 'label': 'Slides'}]}], 'guides': [], 'archive_2025': []}

    def test_only_selected_documents_and_assets_are_published(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            manifest = self.fixture(root, '<img src="plot.svg">')
            (root / 'plot.svg').write_text('<svg xmlns="http://www.w3.org/2000/svg"/>')
            (root / 'submissions').mkdir()
            (root / 'submissions/private.md').write_text('N' + '1234567')
            site = build(root, manifest=manifest)
            self.assertTrue((site / 'slides.html').exists())
            self.assertTrue((site / 'plot.svg').exists())
            self.assertFalse((site / 'submissions').exists())
            self.assertEqual(len(json.loads((site / 'publication-manifest.json').read_text())), 7)

    def test_unselected_document_link_fails(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            manifest = self.fixture(root, '<a href="other.html">Other</a>')
            (root / 'other.html').write_text('Unselected document')
            with self.assertRaises(ValueError):
                build(root, manifest=manifest)

    def test_missing_file_fails(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            manifest = self.fixture(root)
            (root / 'slides.html').unlink()
            with self.assertRaises(ValueError):
                build(root, manifest=manifest)

    def test_symlink_is_not_published(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            manifest = self.fixture(root, '<img src="plot.svg">')
            (root / 'private.svg').write_text('<svg/>')
            (root / 'plot.svg').symlink_to(root / 'private.svg')
            with self.assertRaises(ValueError):
                build(root, manifest=manifest)

    def test_unsafe_output_is_not_replaced(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            manifest = self.fixture(root)
            with self.assertRaises(ValueError):
                build(root, output=root, manifest=manifest)
            unrelated = root / 'unrelated'
            unrelated.mkdir()
            with self.assertRaises(ValueError):
                build(root, output=unrelated, manifest=manifest)


if __name__ == '__main__':
    unittest.main()
