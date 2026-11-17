# NYTS 2025 data for visualisation

The cleaned participant table contains all 23,630 respondents and 31 variables selected from the FDA public-use dataset. It provides readable categories, numeric vaping frequency, and separate tables for multiple-response questions. No participant sampling or complete-case filtering has been applied.

## Files

- `nyts2025_vaping.csv` and `nyts2025_vaping.rds`: one row per participant. Start here.
- `nyts2025_reasons_long.csv` and `.rds`: reasons for first use among 3,471 ever-users, and reasons for current use among 1,395 current users. Each person has 14 rows per applicable question.
- `nyts2025_flavours_long.csv` and `.rds`: 11 flavour options per current user, including nonresponses.
- `variable_dictionary.csv`: sources, meanings, units, factor levels, applicability, and missing counts for the participant table.
- `multiple_response_dictionary.csv`: maps each reason or flavour to its original source question.
- `source_response_audit.csv`: counts of the original codes for every source variable used, including separate missing, skipped, and unanswered codes.

The RDS files preserve factor ordering and variable descriptions. CSV files use readable labels and `NA` for missing values; CSV does not preserve factor ordering. If importing CSV with readr, read `respondent_id` as character.

## Main variables

| Area | Variables | Useful comparisons |
|---|---|---|
| Demographics | `age_group`, `age_years`, `sex`, `school_level`, `grade` | Group differences; faceted plots |
| Vaping history | `ever_vaped`, `current_vaping`, `vaping_status` | Bars or dots showing sample counts or weighted proportions |
| Frequency | `days_vaped_30`, `vaping_frequency` | Discrete-frequency bars, histograms, or distributions by group |
| Initiation | `age_first_vaped_group`, `age_first_vaped_years`, `lifetime_vaping_days_group` | Ordered bars; initiation-age distributions |
| Devices and nicotine | `device_type`, `nicotine_in_vape`, `nicotine_salts_in_vape` | Device use and nicotine knowledge by group |
| Quitting | `quit_intention`, `quit_attempts_group` | Ordered bars; comparison with frequency |
| Other nicotine use | `current_smoking`, `current_nicotine_pouches`, `smoking_vaping_status` | Smoking and vaping overlap |
| Self-reported experiences | `low_interest_frequency`, `low_mood_frequency`, `anxiety_frequency`, `worry_frequency` | Ordinal response distributions by vaping group |

`respondent_id` links the tables. `survey_weight`, `survey_stratum`, and `survey_psu` retain survey design information. `days_vaped_30_response` explains missing vaping-frequency values; `initiation_age_conflict` is a quality flag, not an outcome.

## Cleaning decisions

- Official FDA derived indicators are used for ever-use and past-30-day use, rather than reconstructing them from raw skip patterns. Current use means use on at least one of the past 30 days.
- Missing, not answered, not displayed, skipped, and source edit-check codes become `NA`, never an automatic No or zero. Their original frequencies remain in the response audit. Q8 response status is also retained per participant.
- `days_vaped_30` is the reported Q8 value from 0 to 30. Most never-users skipped this question and therefore have `NA` here, not zero. For a distribution among current users, filter `current_vaping == "Yes"`; for overall prevalence, use `current_vaping`, not Q8 completeness.
- Numeric age variables contain exact ages only. Current ages of 19 or older, and initiation ages of 8 or younger or 19 or older, are `NA` in the numeric versions. The ordered group versions retain these respondents. Do not treat these numeric-age missing values as ordinary nonresponse. The age-conflict flag compares only two reported exact ages; it does not check inconsistencies involving open-ended categories.
- Don't know is retained where it is a substantive response. Quit attempts remain ordered ranges, not invented exact counts. No missing ages, days, or symptom responses are imputed, and no clinical symptom score is created.
- `smoking_vaping_status` requires both use indicators to be known. Neither means neither cigarettes nor e-cigarettes, not absence of all nicotine use.
- Raw free-text responses, brand detail, and unrelated questionnaire sections are omitted from this teaching extract.

## Multiple responses and denominators

The reasons table has a `context` column distinguishing First use from Current use. Reasons and flavours have a logical `selected` column: TRUE for selected, FALSE for an unchecked option in an answered question, and NA for unavailable responses. `question_answered` identifies whether at least one option was selected. `response_status` distinguishes skipped, not displayed, and unanswered items. Demographics and survey weights are repeated on each option row to support faceting and weighted summaries.

For a percentage among respondents who answered a question, first restrict to the relevant context and `question_answered == TRUE`, then calculate `mean(selected)` separately for each reason or flavour. For population-weighted percentages, use `weighted.mean(selected, survey_weight)` within each option instead. Label this denominator explicitly: it excludes people who did not answer. For a denominator of all eligible users, report the missing responses rather than silently treating them as No. Multiple options can be selected, so percentages across options need not sum to 100. Do not count long-table rows as separate participants or calculate participant totals by summing repeated weights across options.

## Open and plot in R

From the module project root:

```r
vaping <- readRDS("2026/datasets/nyts-2025/cleaned/nyts2025_vaping.rds")
reasons <- readRDS("2026/datasets/nyts-2025/cleaned/nyts2025_reasons_long.rds")
flavours <- readRDS("2026/datasets/nyts-2025/cleaned/nyts2025_flavours_long.rds")

library(ggplot2)
ggplot(subset(vaping, current_vaping == "Yes"), aes(days_vaped_30)) +
  geom_histogram(binwidth = 1, boundary = -0.5) +
  facet_wrap(~school_level) +
  labs(x = "Days vaping in the past 30 days", y = "Respondents")
```

This example describes the unweighted sample. National estimates require survey weights, and confidence intervals also require the sampling design. The survey is cross-sectional: group differences do not establish causes. Symptom items are self-reports, not diagnoses. FDA conditions prohibit attempts to identify respondents or schools and prohibit subnational analyses; the stratum and PSU variables are included for survey design, not geographical mapping. See the [FDA source and use conditions](https://www.fda.gov/tobacco-products/youth-and-tobacco/national-youth-tobacco-survey-nyts) and the original codebook, questionnaire, and methodology report in the parent folder.

## Rebuild and check

Run from the module project root:

```sh
Rscript 2026/datasets/nyts-2025/prepare_visualisation_data.R
Rscript 2026/datasets/nyts-2025/check_visualisation_data.R
```

The scripts use the existing `nyts2025.rds` without changing it. Validation checks the source codes, record retention, missing values, multiple-response options and denominators, CSV/RDS consistency, and basic plotting compatibility.
