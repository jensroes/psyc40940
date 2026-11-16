# Publishing the teaching materials

The course site is https://jensroes.github.io/psyc40940/.

GitHub Pages publishes the rendered materials selected in `site_manifest.json`:
2026 slides, browser session guides, student exercise ZIPs, available PowerPoint
files, submission guides, and a separate archive of 2025 slides.
The repository itself is public; the site is a smaller, explicit selection.
Student submissions, communications, personal records and individual feedback
belong in the ignored local folders and on NOW. Instructor answer folders are
also excluded. `.gitignore` protects local folders; it cannot remove anything
already committed, so review the file list before committing.

## Update an existing session

1. Edit and render the session using the existing scripts in `2026/scripts/`.
   The publisher copies rendered HTML; it does not run R or regenerate slides.
2. Rebuild the student exercise ZIP if its contents changed.
3. Run the checks below and review the selected files before committing.
4. Run `python3 publishing/publish_site.py`. It audits the repository, rebuilds
   the selected materials and pushes only the generated site to `gh-pages`.
5. Commit the public source/output changes to `main` separately when ready.
   Publishing from the working folder does not commit unrelated course edits.

```sh
python3 publishing/audit_publication.py --history
python3 publishing/build_site.py
python3 -m unittest discover -s publishing -p 'test_*.py'
python3 -m http.server 8000 --directory _site
```

Open http://localhost:8000/ to preview the index. Deployment status is under
GitHub → Actions → pages build and deployment. Pages settings use **Deploy from
a branch**, selecting `gh-pages` and `/ (root)`. GitHub automatically deploys
updates pushed to that branch. Publishing requires network access and the GitHub
credentials already used by Git. It preserves the site branch history and does
not force-push.

## Add a session or resource

Add its rendered file to `site_manifest.json`. Only listed documents and their
local image, font, stylesheet and JavaScript dependencies are included. Linked
documents and downloads must also be explicitly selected. Paths are preserved,
so links work under the `/psyc40940/` project URL. The generated
`publication-manifest.json` lists the deployed files and their SHA-256 hashes.

The checks reject private folder paths, symlinks, unsafe archive paths, common
credential patterns and student-number patterns, including inside teaching ZIPs.
These checks supplement a review; they do not identify every possible personal
detail in prose, images or PDFs. Keep private material outside the public file set.

## Replace RPubs links

`links-2026.md` contains the new slide and guide URLs for NOW. Existing RPubs
publications are untouched. Browser slides retain their interactive Plotly
figures. GitHub Pages serves static files: students download Shiny exercises and
run the R apps in RStudio; Pages does not run a Shiny server.
