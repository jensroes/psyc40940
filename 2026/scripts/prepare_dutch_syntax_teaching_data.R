# Staff preparation only. Students receive the resulting tidy CSVs.
library(readr)
library(dplyr)

repo <- normalizePath(".", mustWork = TRUE)
stopifnot(dir.exists(file.path(repo, "2026")))
base <- file.path(repo, "2026/datasets/dutch-syntax-2023")
raw <- file.path(base, "raw")
dir.create(raw, recursive = TRUE, showWarnings = FALSE)
sources <- data.frame(
  file = c("Longitudinal_Production.csv", "Longitudinal_LexTale_scores.csv"),
  url = c("https://osf.io/download/z9qjc/", "https://osf.io/download/peq6y/")
)
for (i in seq_len(nrow(sources))) {
  path <- file.path(raw, sources$file[i])
  if (!file.exists(path)) download.file(sources$url[i], path, mode = "wb")
}
sources$md5 <- unname(tools::md5sum(file.path(raw, sources$file)))
write_csv(sources, file.path(base, "source-files.csv"))

production <- read_csv(file.path(raw, sources$file[1]),
                       col_types = cols(.default = col_character()),
                       locale = locale(encoding = "Windows-1252"))
lex <- read_delim(file.path(raw, sources$file[2]), delim = ";",
                  col_types = cols(.default = col_character()),
                  name_repair = "minimal", show_col_types = FALSE)
lex <- data.frame(
  source_participant = trimws(lex[["Participant"]]),
  vocabulary_score = parse_number(lex[["LexTale"]]) / 100
)
lex <- filter(lex, !is.na(vocabulary_score))
stopifnot(!anyDuplicated(lex$source_participant))

source_ids <- sort(unique(trimws(production$Participant)))
id_map <- data.frame(source_participant = source_ids,
                     participant = sprintf("P%02d", seq_along(source_ids)))
trials <- data.frame(
  source_participant = trimws(production$Participant),
  study_session = as.integer(production$Session),
  trial_in_session = as.integer(production$Trial),
  item = production$Item,
  prime_condition = recode(production$Condition,
                            BASE = "Baseline", ACT = "Active sentence",
                            PASS = "Passive sentence", INT = "Intervention"),
  phase = recode(production$Intervention,
                  PreInt = "Before", PostInt = "After", Int = "During"),
  response = recode(production$target_cond,
                     ACT = "Active", PASS = "Passive", OTHER = "Other",
                     SP = "Short passive", SKIP = "No response")
)
trials <- left_join(trials, id_map, by = "source_participant")
trials <- left_join(trials, lex, by = "source_participant")
trials <- select(trials, participant, study_session, trial_in_session, item,
                  prime_condition, phase, response, vocabulary_score)
trials <- arrange(trials, participant, study_session, trial_in_session)

# Core plots compare the ordinary target trials before/after the intervention.
# The intervention trials remain available, clearly identified in the trial file.
targets <- filter(trials, phase %in% c("Before", "After"))
rates <- summarise(
  group_by(targets, participant, study_session, prime_condition, phase),
  n_trials = n(),
  n_passive = sum(response == "Passive"),
  n_active = sum(response == "Active"),
  n_other = sum(!response %in% c("Active", "Passive")),
  vocabulary_score = first(vocabulary_score), .groups = "drop"
)
rates <- mutate(rates,
                  passive_percent = 100 * n_passive / n_trials,
                  scorable_trials = n_active + n_passive,
                  passive_percent_scorable = ifelse(
                    scorable_trials > 0, 100 * n_passive / scorable_trials,
                    NA_real_))
rates <- arrange(rates, participant, study_session, prime_condition, phase)

stopifnot(nrow(trials) == 2232L, n_distinct(trials$participant) == 17L,
          nrow(targets) == 1968L, nrow(rates) == 492L,
          sum(rates$n_trials) == nrow(targets), all(rates$n_trials == 4L),
          !anyNA(rates$vocabulary_score),
          all(rates$passive_percent >= 0 & rates$passive_percent <= 100),
          !anyDuplicated(trials[c("participant", "study_session", "trial_in_session")]))

destinations <- c(
  file.path(base, "cleaned"),
  file.path(repo, "2026/week-09-dashboard-workshop/data"),
  file.path(repo, "2026/week-10-wrap-up-assessment-support/submission-example/data")
)
for (destination in destinations) {
  dir.create(destination, recursive = TRUE, showWarnings = FALSE)
  write_csv(trials, file.path(destination, "production_trials.csv"))
  write_csv(rates, file.path(destination, "participant_rates.csv"))
}
cat("Prepared 2,232 production trials and 492 participant/session/condition/phase summaries.\n")
cat("Each summary has four target trials; plot n_passive as counts out of four. Percentage columns are retained as alternatives.\n")
