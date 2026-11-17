# Staff preview figures for the supplied Week 9 study.
library(tidyverse)
d <- read_csv("2026/week-09-dashboard-workshop/data/participant_rates.csv",
               show_col_types = FALSE)
d$phase <- factor(d$phase, levels = c("Before", "After"))
folder <- "2026/week-09-dashboard-workshop/gfx"
dir.create(folder, recursive = TRUE, showWarnings = FALSE)

overview <- ggplot(d, aes(study_session, n_passive,
                           colour = prime_condition, group = prime_condition)) +
  stat_summary(fun = mean, geom = "line") +
  stat_summary(fun.data = mean_se, geom = "errorbar", width = 0.12) +
  stat_summary(fun = mean, geom = "point") +
  facet_wrap(~phase, nrow = 1) +
  scale_colour_manual(values = c("Baseline" = "#009E73",
                                      "Active sentence" = "#0072B2",
                                      "Passive sentence" = "#D55E00")) +
  scale_x_continuous(breaks = 1:5) +
  scale_y_continuous(breaks = 0:4) +
  coord_cartesian(ylim = c(0, 4)) +
  labs(x = "Testing occasion", y = "Mean full passive responses (out of 4)", colour = "Sentence condition") +
  theme_gray(base_size = 13)
overview_phases <- ggplot(d, aes(study_session, n_passive,
                                  colour = phase, group = phase)) +
  stat_summary(fun = mean, geom = "line") +
  stat_summary(fun.data = mean_se, geom = "errorbar", width = 0.12) +
  stat_summary(fun = mean, geom = "point") +
  facet_wrap(~prime_condition, nrow = 1) +
  scale_colour_manual(values = c("Before" = "#0072B2", "After" = "#D55E00")) +
  scale_x_continuous(breaks = 1:5) +
  scale_y_continuous(breaks = 0:4) +
  coord_cartesian(ylim = c(0, 4)) +
  labs(x = "Testing occasion", y = "Mean full passive responses (out of 4)", colour = "Phase") +
  theme_gray(base_size = 13)
individual <- ggplot(d, aes(study_session, n_passive,
                             colour = prime_condition,
                             group = interaction(participant, prime_condition))) +
  geom_line(alpha = 0.45) + geom_point(alpha = 0.45) +
  facet_wrap(~phase, nrow = 1) +
  scale_colour_manual(values = c("Baseline" = "#009E73",
                                      "Active sentence" = "#0072B2",
                                      "Passive sentence" = "#D55E00")) +
  scale_x_continuous(breaks = 1:5) +
  scale_y_continuous(breaks = 0:4, limits = c(0, 4)) +
  labs(x = "Testing occasion", y = "Full passive responses (out of 4)", colour = "Sentence condition") +
  theme_gray(base_size = 13)
heatmap <- ggplot(d, aes(study_session, participant, fill = n_passive)) +
  geom_tile(colour = "white") + facet_grid(phase ~ prime_condition) +
  scale_x_continuous(breaks = 1:5) +
  scale_fill_viridis_c(limits = c(0, 4), breaks = 0:4) +
  labs(x = "Testing occasion", y = "Learner", fill = "Full passives\n(out of 4)") +
  theme_gray(base_size = 13)
for (name in c("overview", "overview_phases", "individual", "heatmap")) {
  ggsave(file.path(folder, paste0("study-", name, ".png")),
         get(name), width = 11, height = 6, dpi = 150)
}
