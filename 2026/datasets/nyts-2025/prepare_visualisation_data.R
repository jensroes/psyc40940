#!/usr/bin/env Rscript

library(dplyr)
library(tidyr)
library(readr)

script <- grep("^--file=", commandArgs(), value = TRUE)
folder <- if (length(script)) {
  dirname(normalizePath(sub("^--file=", "", script[[1]])))
} else {
  "2026/datasets/nyts-2025"
}
raw <- readRDS(file.path(folder, "nyts2025.rds"))
output <- file.path(folder, "cleaned")
dir.create(output, showWarnings = FALSE)

missing_codes <- c(M = "Missing", N = "Not answered", Z = "Not displayed",
                   S = "Skipped", E = "Removed by source edit checks")
raw_codes <- function(x) {
  codes <- as.character(haven::zap_labels(x))
  if (is.numeric(x)) {
    tagged <- haven::is_tagged_na(x)
    codes[tagged] <- toupper(haven::na_tag(x[tagged]))
  }
  codes
}
response_status <- function(codes) {
  result <- rep("Answered", length(codes))
  special <- codes %in% names(missing_codes)
  result[special] <- unname(missing_codes[codes[special]])
  result[is.na(codes) | codes == ""] <- "Missing"
  result[codes == "." & !is.na(codes)] <- "Not selected"
  result
}
answer_codes <- function(source) {
  codes <- raw_codes(raw[[source]])
  codes[codes %in% names(missing_codes)] <- NA_character_
  codes
}
categorical <- function(source, labels = NULL, ordered = FALSE) {
  if (is.null(labels)) {
    source_labels <- attr(raw[[source]], "labels")
    values <- as.character(source_labels)
    keep <- !is.na(source_labels) & !values %in% names(missing_codes)
    labels <- setNames(names(source_labels)[keep], values[keep])
  }
  codes <- answer_codes(source)
  stopifnot(all(is.na(codes) | codes %in% names(labels)))
  factor(unname(labels[codes]), levels = unique(unname(labels)), ordered = ordered)
}
numeric_answer <- function(source, minimum = -Inf, maximum = Inf) {
  codes <- answer_codes(source)
  values <- as.numeric(codes)
  stopifnot(all(is.na(codes) | is.finite(values)),
            all(is.na(values) | (values >= minimum & values <= maximum)))
  values
}

dictionary <- list()
core <- tibble(respondent_id = raw_codes(raw$artificial_id))
add <- function(name, value, source, description, group = "All respondents",
                notes = "", units = "") {
  stopifnot(length(value) == nrow(raw), !name %in% names(dictionary))
  attr(value, "label") <- description
  core[[name]] <<- value
  dictionary[[name]] <<- tibble(
    variable = name, source_variable = source, description = description,
    type = if (is.ordered(value)) "Ordered category" else if (is.factor(value)) {
      "Category"
    } else typeof(value),
    units = units, applicable_group = group,
    levels = paste(levels(value), collapse = " | "), notes = notes
  )
}
add("respondent_id", raw_codes(raw$artificial_id), "artificial_id",
    "Anonymous respondent identifier", notes = "Link tables using this column; not a measurement.")
add("age_group", categorical("Q1", ordered = TRUE), "Q1", "Current age category",
    notes = "The oldest category is 19 years or older, not an exact age.")
age <- numeric_answer("Q1", 1, 11)
age <- ifelse(age <= 10, age + 8, NA_real_)
add("age_years", age, "Q1", "Exact current age where available",
    notes = "19 years or older is NA here; use age_group to retain those respondents.", units = "years")
add("sex", categorical("SEX"), "SEX", "Sex reported in the survey",
    notes = "Uses the FDA derived variable, whose coding differs from raw Q2.")
add("school_level", categorical("SCHOOLTYPE"), "SCHOOLTYPE", "Grade-derived school level")
add("grade", categorical("Q3"), "Q3", "School grade",
    notes = "Factor levels follow grades 6-12, then ungraded or other grade.")
add("ever_vaped", categorical("EELCIGT"), "EELCIGT", "Ever used an e-cigarette",
    notes = "Official FDA derived Yes/No indicator, not a percentage per respondent.")
add("current_vaping", categorical("CELCIGT"), "CELCIGT", "Vaped on at least one of the past 30 days",
    notes = "Official FDA derived Yes/No indicator. Missing remains NA.")
status <- case_when(
  core$current_vaping == "Yes" ~ "Used in past 30 days",
  core$ever_vaped == "No" ~ "Never used",
  core$ever_vaped == "Yes" & core$current_vaping == "No" ~ "Ever used, not past 30 days",
  .default = NA_character_
)
add("vaping_status", factor(status, levels = c("Never used", "Ever used, not past 30 days",
                                               "Used in past 30 days")),
    "EELCIGT; CELCIGT", "Combined vaping history",
    notes = "Requires known ever/current indicators for the relevant category; unresolved histories remain NA.")
days <- numeric_answer("Q8", 0, 30)
add("days_vaped_30", days, "Q8", "Reported days vaping in the past 30 days",
    "Respondents routed to Q8, mainly ever-users",
    "Skipped questions remain NA, including for never-users; no zeros are imputed.", "days")
add("days_vaped_30_response", factor(response_status(raw_codes(raw$Q8))), "Q8",
    "Response status for the vaping-days question",
    notes = "Distinguishes an answered question from skipped, not displayed, or not answered.")
frequency <- cut(days, breaks = c(-0.5, 0.5, 5.5, 19.5, 29.5, 30.5),
                 labels = c("0 days", "1-5 days", "6-19 days", "20-29 days", "30 days"),
                 ordered_result = TRUE)
add("vaping_frequency", frequency, "Q8", "Grouped reported vaping frequency",
    "Respondents with a valid Q8 response", "Teaching categories; NA when Q8 was not answered.")
add("age_first_vaped_group", categorical("Q6", ordered = TRUE), "Q6", "Age at first e-cigarette use",
    "Ever-users", "Youngest and oldest categories are open-ended.")
first_age <- numeric_answer("Q6", 1, 12)
first_age <- ifelse(first_age %in% 2:11, first_age + 7, NA_real_)
add("age_first_vaped_years", first_age, "Q6", "Exact age at first use where available",
    "Ever-users", "8 or younger and 19 or older are NA here; retained in age_first_vaped_group.", "years")
add("initiation_age_conflict", ifelse(is.na(age) | is.na(first_age), NA, first_age > age),
    "Q1; Q6", "Reported exact initiation age exceeds exact current age",
    "Respondents with both exact ages", "Quality flag only; source responses are not silently corrected.")
add("lifetime_vaping_days_group", categorical("Q7", ordered = TRUE), "Q7",
    "Lifetime days of e-cigarette use", "Ever-users", "Grouped responses, not exact counts.")
add("device_type", categorical("Q12", c("1" = "Disposable", "2" = "Pod or cartridge",
    "3" = "Refillable tank", "4" = "Don't know")), "Q12",
    "Main type of e-cigarette used in the past 30 days", "Current users",
    "If several types were used, the question asks about the one used most often.")
add("nicotine_in_vape", categorical("Q15"), "Q15", "Any recent e-cigarette contained nicotine",
    "Current users", "Don't know is retained as an explicit response, not recoded to No.")
add("nicotine_salts_in_vape", categorical("Q16", c("1" = "Yes", "2" = "No", "3" = "Don't know")),
    "Q16", "Any recent e-cigarette contained nicotine salts", "Current users")
add("quit_intention", categorical("Q25", c("1" = "Within 30 days", "2" = "Within 6 months",
    "3" = "Within 12 months", "4" = "Later than 12 months", "5" = "Not thinking about quitting"), TRUE),
    "Q25", "Intention to quit vaping", "Current users")
add("quit_attempts_group", categorical("Q26", c("1" = "No attempts", "2" = "1 attempt",
    "3" = "2 attempts", "4" = "3-5 attempts", "5" = "6-9 attempts", "6" = "10 or more attempts"), TRUE),
    "Q26", "Attempts to quit vaping in the past 12 months", "Current users",
    "Ordered groups, not a continuous number of attempts.")
add("current_smoking", categorical("CCIGT"), "CCIGT", "Smoked cigarettes in the past 30 days",
    notes = "Official FDA derived indicator.")
add("current_nicotine_pouches", categorical("CPOUCH"), "CPOUCH", "Used nicotine pouches in the past 30 days",
    notes = "Official FDA derived indicator.")
dual_use <- case_when(
  core$current_vaping == "Yes" & core$current_smoking == "Yes" ~ "Both",
  core$current_vaping == "Yes" & core$current_smoking == "No" ~ "Vaping only",
  core$current_vaping == "No" & core$current_smoking == "Yes" ~ "Smoking only",
  core$current_vaping == "No" & core$current_smoking == "No" ~ "Neither",
  .default = NA_character_
)
add("smoking_vaping_status", factor(dual_use, levels = c("Neither", "Vaping only", "Smoking only", "Both")),
    "CELCIGT; CCIGT", "Combined past-30-day cigarette and e-cigarette use",
    notes = "Neither refers only to cigarettes and e-cigarettes, not all nicotine products. Both indicators must be known.")
symptoms <- c(low_interest = "Q156", low_mood = "Q157", anxiety = "Q158", worry = "Q159")
for (name in names(symptoms)) {
  source <- symptoms[[name]]
  add(paste0(name, "_frequency"), categorical(source, ordered = TRUE), source,
      attr(raw[[source]], "label"), notes = "Past two weeks; an individual self-report item, not a diagnosis or causal explanation.")
}
add("survey_weight", numeric_answer("WT_analysis", 0), "WT_analysis", "FDA analysis weight",
    notes = "Use for population-level descriptive proportions; not for ordinary sample counts.")
add("survey_stratum", raw_codes(raw$Stratum), "Stratum", "Survey sampling stratum",
    notes = "Design variable, not a geographical plotting category.")
add("survey_psu", raw_codes(raw$PSU), "PSU", "Primary sampling unit",
    notes = "Design variable for survey uncertainty estimates; not a geographical plotting category.")

reason_labels <- c("Friends", "Family", "Quit other tobacco", "Lower cost", "Easy access",
                   "Media exposure", "Perceived lower harm", "Flavours", "Use unnoticed",
                   "Vape tricks", "Curiosity", "Anxiety, stress or low mood", "Nicotine buzz", "Other")
flavour_labels <- c("Tobacco", "Menthol", "Mint", "Spice", "Fruit", "Chocolate",
                    "Alcoholic drink", "Non-alcoholic drink", "Candy or desserts", "Unflavoured", "Other")
item_dictionary <- list()
make_multiple_response <- function(sources, labels, eligible, context, item_name, table_name) {
  codes <- lapply(raw[sources], raw_codes)
  selected <- vapply(codes, function(x) !is.na(x) & x == "1", logical(nrow(raw)))
  answered <- rowSums(selected) > 0
  eligible <- !is.na(eligible) & eligible
  stopifnot(!any(answered & !eligible),
            all(vapply(codes, function(x) all(is.na(x) | x %in% c("1", ".", names(missing_codes))), logical(1))))
  # A dot is an unchecked option only within an answered multi-response question.
  item_data <- as_tibble(codes) |>
    mutate(row_index = seq_len(nrow(raw))) |>
    filter(eligible) |>
    pivot_longer(all_of(sources), names_to = "source_variable", values_to = "response_code") |>
    mutate(respondent_id = core$respondent_id[row_index], context = context,
           item = factor(unname(setNames(labels, sources)[source_variable]), levels = labels),
           question_answered = answered[row_index],
           selected = case_when(response_code == "1" ~ TRUE,
                                response_code == "." & question_answered ~ FALSE,
                                .default = NA),
           response_status = response_status(response_code),
           response_status = case_when(response_code == "." & question_answered ~ "Answered",
                                       response_code == "." ~ "No option selected",
                                       .default = response_status)) |>
    select(respondent_id, context, item, selected, question_answered, response_status, source_variable) |>
    rename(!!item_name := item) |>
    left_join(select(core, respondent_id, age_group, age_years, sex, school_level,
                     days_vaped_30, survey_weight, survey_stratum, survey_psu), by = "respondent_id")
  item_dictionary[[context]] <<- tibble(table = table_name, context = context,
    source_variable = sources, item = labels,
    original_question = vapply(raw[sources], function(x) attr(x, "label"), character(1)))
  item_data
}
reasons <- bind_rows(
  make_multiple_response(paste0("Q10", letters[1:14]), reason_labels, core$ever_vaped == "Yes",
                         "First use", "reason", "reasons"),
  make_multiple_response(paste0("Q11", letters[1:14]), reason_labels, core$current_vaping == "Yes",
                         "Current use", "reason", "reasons")
)
flavours <- make_multiple_response(paste0("Q17a_", letters[1:11]), flavour_labels,
    core$current_vaping == "Yes", "Past 30 days", "flavour", "flavours")

dictionary <- bind_rows(dictionary) |>
  mutate(n_observed = vapply(core, function(x) sum(!is.na(x)), integer(1)),
         n_missing = vapply(core, function(x) sum(is.na(x)), integer(1)))
sources <- unique(c(unlist(strsplit(dictionary$source_variable, "; ", fixed = TRUE)),
                    paste0("Q10", letters[1:14]), paste0("Q11", letters[1:14]), paste0("Q17a_", letters[1:11])))
audit <- bind_rows(lapply(sources, function(source) {
  codes <- raw_codes(raw[[source]])
  tibble(source_variable = source, response_code = codes, response_status = response_status(codes)) |>
    count(source_variable, response_code, response_status, name = "n")
}))

write_csv(core, file.path(output, "nyts2025_vaping.csv"), na = "NA")
saveRDS(core, file.path(output, "nyts2025_vaping.rds"))
write_csv(reasons, file.path(output, "nyts2025_reasons_long.csv"), na = "NA")
saveRDS(reasons, file.path(output, "nyts2025_reasons_long.rds"))
write_csv(flavours, file.path(output, "nyts2025_flavours_long.csv"), na = "NA")
saveRDS(flavours, file.path(output, "nyts2025_flavours_long.rds"))
write_csv(dictionary, file.path(output, "variable_dictionary.csv"), na = "NA")
write_csv(bind_rows(item_dictionary), file.path(output, "multiple_response_dictionary.csv"), na = "NA")
write_csv(audit, file.path(output, "source_response_audit.csv"), na = "NA")
cat("Saved", nrow(core), "respondents and", ncol(core), "variables.\n",
    "Reasons:", nrow(reasons), "rows; flavours:", nrow(flavours), "rows.\n")
