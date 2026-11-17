library(tidyverse)

d_trials <- read_csv("data/spellname.csv", show_col_types = FALSE)
d_participants <- summarise(
  d_trials,
  mean_rt = mean(rt, na.rm = TRUE),
  .by = c(ppt_id, modality)
)
d_participants <- arrange(d_participants, modality, ppt_id)
write_csv(d_participants, "data/participant_reaction_times.csv")
