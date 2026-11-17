"""Prepare the supplied trial-level CSV for the short Week 9 Plotly exercise."""
from pathlib import Path
import csv
import math

root = Path(__file__).resolve().parents[1]
source = root / 'week-06-shiny-basics-reactivity/data/spellname.csv'
destination = root / 'week-09-dashboard-workshop/data/trial_reaction_times.csv'
with source.open() as handle:
    raw = list(csv.DictReader(handle))
rows = []
for row in raw:
    rows.append(dict(ppt_id=row['ppt_id'], trial_id=row['trial_id'],
                     stimulus=Path(row['image_id']).stem,
                     modality=row['modality'], rt=float(row['rt']), dur=float(row['dur']),
                     vocabulary_score=round(float(row['ppt_vocab']), 4)))
assert len(rows) == 8648
assert len({r['ppt_id'] for r in rows}) == 72
assert len({(r['ppt_id'], r['trial_id'], r['modality']) for r in rows}) == len(rows)
assert all(math.isfinite(r['rt']) and math.isfinite(r['dur']) and
           math.isfinite(r['vocabulary_score']) for r in rows)
for participant in {r['ppt_id'] for r in rows}:
    assert len({r['vocabulary_score'] for r in rows if r['ppt_id'] == participant}) == 1
with destination.open('w', newline='') as handle:
    writer = csv.DictWriter(handle, fieldnames=list(rows[0]))
    writer.writeheader()
    writer.writerows(rows)
print(f'{destination}: {len(rows)} trials from 72 participants; no trial exclusions.')
