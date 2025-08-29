library(tidyverse)

# File names
list.files("data", full.names = T)

d_sem <- read_csv("data/zzz/semcat.csv") %>%
  mutate(cat = case_when(is_manmade < .3 ~ "is natural",
                         is_manmade > .7 ~ "is manmade",
                         TRUE ~ "no bias")) %>%
  select(image_id, cat, semcat)

d_item <- read_csv("data/zzz/by_item.csv") %>%
  select(image_id, mc_resp = resp, nsyl, nchar, nphon) %>%
  glimpse()

d_sp <- read_csv("data/zzz/spoken_production_familiarisation.csv" ) %>%
  rename(freq = fr_sp_pm) %>%
  mutate(modality = "speech") %>%
  glimpse()

d_wr <- read_csv("data/zzz/written_production_familiarisation.csv" ) %>%
  rename(freq = fr_wr_pm) %>%
  filter(loc == "onset", !full_word_deleted) %>%
  mutate(modality = "writing") %>%
  rename(onset = iki) %>%
  glimpse()


bind_rows(d_sp, d_wr) %>%
  select(-trial_id, -offset, -item) %>%
  mutate(across(id, ~as.numeric(factor(.)))) %>%
  select(-key:-nchar, -nsyl, -nphon, -semcat) %>%
  left_join(d_item, by = join_by(image_id)) %>%
  left_join(d_sem, by = join_by(image_id)) %>%
  mutate(freq = freq + 3,
         semcat = scale(log(semcat))[,1]) %>%
  filter(onset > 0, onset < 1e4) %>%
  rename(name_familiarised = is_new,
         used_exp_name = is_target,
         ppt_vocab = lextale_score,
         rt = onset,
         spell_div = h_spell,
         name_div = h_name,
         ppt_id = id) %>%
  write_csv("data/spellname.csv")






