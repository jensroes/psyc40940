remotes::install_github("tylermorganwall/rayshader")
library(rayshader)
library(tidyverse)

# Load the blomkvist data and store them in the variable `blomkvist`
blomkvist <- read_csv("data/blomkvist.csv") %>% drop_na(rt_hand_nd, rt_foot_nd)

# Create a plot
plot <- ggplot(blomkvist, aes(x = rt_hand_nd, y = rt_foot_nd)) +
  stat_density_2d(aes(fill = after_stat(nlevel)),
                  geom = "polygon",
                  n = 200, bins = 20, contour = TRUE) +
  scale_fill_viridis_c(option = "A",
                       guide = guide_colourbar(ticks = element_blank())) +
  theme_light(base_size = 14) +
  labs(x = "Reaction time hand (in msecs)",
       y = "Reaction time foot (in msecs)")

# Make it 3D
plot_gg(plot, multicore=TRUE, width=6, height=6, scale=250)
