library(tidyverse)

d_trials <- read_csv("data/spellname_source.csv", show_col_types = FALSE)
d_workshop <- d_trials |>
  group_by(ppt_id, modality) |>
  summarise(mean_rt = mean(rt, na.rm = TRUE),
            mean_duration = mean(dur, na.rm = TRUE),
            vocabulary_score = first(ppt_vocab),
            .groups = "drop") |>
  arrange(modality, ppt_id)
write_csv(d_workshop, "data/participant_behaviour.csv")
