# National Youth Tobacco Survey 2025

Official FDA public-use data downloaded on 27 October 2026. The original dataset contains 23,630 records and 1,453 variables. It is retained unchanged.

For visualisation work, start with [the cleaned dataset guide](cleaned/README.md). The `cleaned/` folder contains a 31-variable participant table in CSV and RDS formats, plus long-format reasons and flavours tables, dictionaries, and an audit of the original response codes.

## Files

- `nyts-2025-source.zip`: unchanged FDA download, containing the SAS data, format catalogue, and codebook.
- `raw/2025 NYTS Codebook/`: extracted contents of that ZIP. The codebook PDF is version 2-28-26. The 132 MiB extracted SAS data file is ignored by Git; recreate it from the retained source ZIP before importing.
- `nyts2025.rds`: R copy imported with `haven::read_sas()` and the supplied format catalogue. Variable labels, value labels, original codes, and all records are retained.
- `documentation/nyts-2025-questionnaire.pdf`: survey questions and routing instructions.
- `documentation/nyts-2025-methodology.pdf`: sampling, weighting, and analysis guidance.

## Open in R

From the module project root:

```r
vaping <- readRDS("2026/datasets/nyts-2025/cleaned/nyts2025_vaping.rds")
```

The original full dataset remains available as:

```r
nyts <- readRDS("2026/datasets/nyts-2025/nyts2025.rds")
```

To recreate the RDS from the original download:

```r
folder <- "2026/datasets/nyts-2025"
raw_folder <- file.path(folder, "raw", "2025 NYTS Codebook")
unzip(file.path(folder, "nyts-2025-source.zip"),
      exdir = file.path(folder, "raw"))
nyts <- haven::read_sas(
  file.path(raw_folder, "nyts2025_puf.sas7bdat"),
  catalog_file = file.path(raw_folder, "format.sas7bcat")
)
saveRDS(nyts, file.path(folder, "nyts2025.rds"), compress = "xz")
```

## Coding and use

Many questionnaire variables are labelled character vectors. Codes are not automatically converted into factor labels or numeric measurements. For example, `Q8` records days of e-cigarette use during the past 30 days as strings from `"0"` to `"30"`, alongside special response codes. The catalogue defines `M` as missing, `N` as not answered, `Z` as not displayed, `S` as skipped, and `E` as missing due to edit checks. Do not interpret these codes as zero use. Consult the questionnaire routing and codebook before recoding them.

Population estimates require the appropriate survey weights and design information; unweighted plots describe the sample. FDA conditions prohibit identification or linkage intended to identify individuals or schools, subnational analyses, and claims that interpretations represent FDA policy. See the [FDA source page and use conditions](https://www.fda.gov/tobacco-products/youth-and-tobacco/national-youth-tobacco-survey-nyts).

## Download sources

- [Dataset ZIP](https://www.fda.gov/media/191376/download?attachment=)
- [Questionnaire](https://www.fda.gov/media/191363/download?attachment=)
- [Methodology report](https://www.fda.gov/media/191362/download?attachment=)
