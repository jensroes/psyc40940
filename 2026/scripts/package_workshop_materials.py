from pathlib import Path
import zipfile

root=Path(__file__).resolve().parents[1]
week9=root/'week-09-dashboard-workshop'
week10=root/'week-10-wrap-up-assessment-support'
files9=['README.md','session-guide.html','plotly_app.R',
        'plotly_worked_app.R','supplied_data_app.R','worked_example_app.R',
        'extension_app.R','own_data_app.R','reactivity-graph-template.svg','data/README.md','data/trial_reaction_times.csv',
        'data/participant_rates.csv','data/production_trials.csv']
files10=['README.md','session-guide.html',
         'submission-example/README.md','submission-example/portfolio.Rproj',
         'submission-example/report.Rmd','submission-example/report.html',
         'submission-example/references.bib','submission-example/apa.csl',
         'submission-example/app/app.R','submission-example/data/README.md',
         'submission-example/data/participant_rates.csv',
         'submission-example/data/production_trials.csv']
files10 += [str(p.relative_to(week10)) for p in sorted((week10/'assessment-briefs').iterdir())
            if p.suffix in ('.docx','.html')]
for week,files in [(week9,files9),(week10,files10)]:
    destination=root/'student-zips'/('psyc40940-'+week.name+'.zip')
    for name in files:
        assert (week/name).is_file(),name
    with zipfile.ZipFile(destination,'w',zipfile.ZIP_DEFLATED) as z:
        for name in files: z.write(week/name,week.name+'/'+name)
    with zipfile.ZipFile(destination) as z:
        assert z.testzip() is None
        assert not any('/archive/' in n or 'spellname_source' in n or 'participant_behaviour' in n for n in z.namelist())
        assert not any('/gfx/' in n or n.endswith('/session-guide.Rmd') for n in z.namelist())
        for name in files: assert z.read(week.name+'/'+name)==(week/name).read_bytes()
    print(destination.name,len(files),'files; checked against current sources')

