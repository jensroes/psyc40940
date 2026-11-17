from pathlib import Path
from zipfile import ZipFile, ZIP_DEFLATED

root = Path(__file__).resolve().parents[1]
week = root / "week-08-tabs-controls"
files = ["README.md", "session-guide.html", "intro_app.R", "starter_app.R",
         "controls_app.R", "worked_example_app.R", "extension_app.R",
         "optional_density_app.R", "optional_histogram_app.R",
         "data/participant_reaction_times.csv", "data/README.md"]
destination = root / "student-zips/psyc40940-week-08-tabs-controls.zip"
for name in files:
    assert (week / name).is_file(), name
with ZipFile(destination, "w", ZIP_DEFLATED) as archive:
    for name in files:
        archive.write(week / name, week.name + "/" + name)
with ZipFile(destination) as archive:
    assert archive.testzip() is None
    assert not any("/answers/" in name or "_answer.R" in name or
                   name.endswith(".Rmd") or "/gfx/" in name
                   for name in archive.namelist())
    for name in files:
        assert archive.read(week.name + "/" + name) == (week / name).read_bytes()
print(f"{destination.name}: {len(files)} verified files; private answers excluded.")
