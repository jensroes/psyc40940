# Load packages
library(tidyverse)

# Custome function for se
se <- function(x) sqrt( mean(x) * (1 - mean(x)) / length(x) )

# get the file names
files <- list.files("data", pattern = "vanLieburg", full.names = T)

# import data
data_baseline <- read_csv(files[1]) %>%
  filter(target_cond != "OTHER", Condition != "INT") %>%
  count(Condition, target_cond) %>%
  mutate(freq = n / sum(n) * 100, .by = Condition) %>%
  mutate(group = "Pre-intervention")

data_int <- read_csv(files[2]) %>%
  filter(target_cond != "OTHER") %>%
  count(Condition, target_cond) %>%
  mutate(freq = n / sum(n) * 100, .by = Condition) %>%
  mutate(group = "Intervention")

data_cross <- read_csv(files[3]) %>%
  filter(target_cond != "OTHER", Condition != "INT") %>%
  count(Condition, target_cond) %>%
  mutate(freq = n / sum(n) * 100, .by = Condition) %>%
  mutate(group = "Post-intervention")

data <- bind_rows(data_baseline, data_int, data_cross) %>%
  mutate(across(group, ~factor(., levels = c("Pre-intervention", "Post-intervention", "Intervention"), ordered = TRUE)),
         across(target_cond, ~factor(., levels = c("PASS", "ACT"), ordered = TRUE)))

ggplot(data, aes(x = Condition, y = freq, fill = target_cond)) +
  facet_wrap(~group, scales = "free") +
  geom_histogram(stat = "identity", position = "stack") +
  geom_text(aes(label = round(freq, digits = 2)), position = position_stack(vjust = 0.5)) +
  theme_bw() +
  theme(panel.spacing = unit(0, "lines"),
        text = element_text(size = 15)) +
  labs(x = "Prime Condition", y = "Produced in %", fill = "Target structure")


# import data





read_csv("data/vanLieburg2024_ControlGroup.csv") %>%
  filter(target_cond != "OTHER", Condition != "INT") %>%
  select(ppt = Participant, item = Item, dv = target_cond, iv = Condition) %>%
  mutate(dv = dv == "PASS") %>%
  summarise(across(dv, list(mean = mean), .names = "{col}"), .by = c(iv, ppt)) %>%
  summarise(across(dv, list(mean = mean, sd = sd)), .by = c(iv)) %>%
  ggplot(aes(y = dv_mean, x = iv)) +
  geom_jitter()
