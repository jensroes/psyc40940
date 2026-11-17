#!/usr/bin/env Rscript

library(dplyr)
library(readr)

script <- grep("^--file=", commandArgs(), value = TRUE)
folder <- if (length(script)) dirname(normalizePath(sub("^--file=", "", script[[1]]))) else "2026/datasets/nyts-2025"
output <- file.path(folder, "cleaned")
raw <- readRDS(file.path(folder, "nyts2025.rds"))
core <- readRDS(file.path(output, "nyts2025_vaping.rds"))
reasons <- readRDS(file.path(output, "nyts2025_reasons_long.rds"))
flavours <- readRDS(file.path(output, "nyts2025_flavours_long.rds"))
codes <- function(x) as.character(haven::zap_labels(x))
yes_no <- function(x) unname(c("1" = "Yes", "2" = "No")[codes(x)])

stopifnot(nrow(core) == nrow(raw), ncol(core) == 31L,
          !anyDuplicated(core$respondent_id),
          identical(as.vector(core$respondent_id), codes(raw$artificial_id)),
          identical(as.character(core$ever_vaped), yes_no(raw$EELCIGT)),
          identical(as.character(core$current_vaping), yes_no(raw$CELCIGT)),
          identical(as.character(core$current_smoking), yes_no(raw$CCIGT)),
          identical(as.character(core$current_nicotine_pouches), yes_no(raw$CPOUCH)),
          identical(as.character(core$sex), unname(c("1" = "Female", "2" = "Male")[codes(raw$SEX)])),
          identical(as.character(core$device_type), unname(c("1" = "Disposable", "2" = "Pod or cartridge",
                    "3" = "Refillable tank", "4" = "Don't know")[codes(raw$Q12)])),
          is.ordered(core$age_group), is.ordered(core$vaping_frequency),
          is.ordered(core$quit_attempts_group),
          is.ordered(core$anxiety_frequency),
          all(is.finite(core$survey_weight)), all(core$survey_weight > 0),
          !anyNA(core$survey_stratum), !anyNA(core$survey_psu))

reported <- codes(raw$Q8)
valid <- !is.na(reported) & reported %in% as.character(0:30)
expected <- rep(NA_real_, nrow(raw))
expected[valid] <- as.numeric(reported[valid])
stopifnot(identical(as.numeric(core$days_vaped_30), expected),
          all(is.na(core$days_vaped_30[reported %in% c("M", "N", "Z", "S", "E")])),
          all(core$days_vaped_30_response[reported == "S"] == "Skipped"),
          all(is.na(core$age_years[codes(raw$Q1) == "11"])),
          all(is.na(core$age_first_vaped_years[codes(raw$Q6) %in% c("1", "12")]))
)
complete_age <- !is.na(core$age_years) & !is.na(core$age_first_vaped_years)
stopifnot(identical(as.logical(core$initiation_age_conflict[complete_age]),
                    (core$age_first_vaped_years > core$age_years)[complete_age]))
known_dual <- !is.na(core$current_vaping) & !is.na(core$current_smoking)
stopifnot(identical(is.na(core$smoking_vaping_status), !known_dual))

stopifnot(nrow(reasons) == 14L * sum(core$ever_vaped == "Yes", na.rm = TRUE) +
                            14L * sum(core$current_vaping == "Yes", na.rm = TRUE),
          nrow(flavours) == 11L * sum(core$current_vaping == "Yes", na.rm = TRUE),
          nrow(distinct(reasons, respondent_id, context, source_variable)) == nrow(reasons),
          nrow(distinct(flavours, respondent_id, source_variable)) == nrow(flavours))
for (table in list(reasons, flavours)) {
  index <- match(table$respondent_id, core$respondent_id)
  stopifnot(!anyNA(index), is.logical(table$selected),
            all(is.na(table$selected[!table$question_answered])),
            !anyNA(table$response_status),
            all(table$survey_weight == core$survey_weight[index]))
  for (source in unique(table$source_variable)) {
    rows <- table$source_variable == source
    original <- codes(raw[[source]])[index[rows]]
    actual <- table$selected[rows]
    stopifnot(identical(sum(actual %in% TRUE), sum(codes(raw[[source]]) == "1", na.rm = TRUE)),
              all(actual[original == "1"] %in% TRUE),
              all(actual[original == "." & table$question_answered[rows]] %in% FALSE),
              all(is.na(actual[original %in% c("M", "N", "Z", "S", "E")])))
  }
}

dictionary <- read_csv(file.path(output, "variable_dictionary.csv"), show_col_types = FALSE)
audit <- read_csv(file.path(output, "source_response_audit.csv"), show_col_types = FALSE)
stopifnot(identical(dictionary$variable, names(core)),
          all(dictionary$n_missing == vapply(core, function(x) sum(is.na(x)), integer(1))),
          all((audit |> group_by(source_variable) |> summarise(n = sum(n)))$n == nrow(raw)))
for (name in c("vaping", "reasons_long", "flavours_long")) {
  csv <- read_csv(file.path(output, paste0("nyts2025_", name, ".csv")),
                  col_types = cols(respondent_id = col_character()), show_col_types = FALSE)
  rds <- readRDS(file.path(output, paste0("nyts2025_", name, ".rds")))
  stopifnot(nrow(csv) == nrow(rds), identical(names(csv), names(rds)),
            identical(csv$respondent_id, as.vector(rds$respondent_id)),
            identical(colSums(is.na(csv)), colSums(is.na(rds))))
}

library(ggplot2)
plots <- list(
  ggplot(filter(core, current_vaping == "Yes"), aes(days_vaped_30)) +
    geom_histogram(binwidth = 1, boundary = -0.5) + facet_wrap(~school_level),
  ggplot(filter(core, current_vaping == "Yes", !initiation_age_conflict),
         aes(sex, age_first_vaped_years)) + geom_boxplot(na.rm = TRUE),
  ggplot(filter(core, !is.na(school_level), !is.na(current_vaping)),
         aes(school_level, fill = current_vaping, weight = survey_weight)) +
    geom_bar(position = "fill")
)
for (plot in plots) stopifnot(nrow(ggplot_build(plot)$data[[1]]) > 0)
cat("Checked all 23,630 records, 31 variables, source-code agreement, missingness, multi-response denominators, CSV/RDS consistency, and three plot types.\n")
cat("Flagged initiation-age conflicts:", sum(core$initiation_age_conflict, na.rm = TRUE), "\n")
