# Load tidyverse package (which includes ggplot2 and many other useful
# functions for data processing).
# If you haven't installed tidyverse, uncomment (delete the "#") and run the next line:
# install.packages("tidyverse")
library(tidyverse)
# We also need the "psyntur" package. Again, if it is not installed, please do
# install it using the next line:
# install.packages("psyntur")
library(psyntur)

# Load the data
d_blomkvist <- read_csv("data/blomkvist.csv")

# Explore the data blomkvist with glimpse()
glimpse(---) # replace "---"

# These are average reaction time data for people playing a video game published in
# Blomkvist et al. (2017).

# Reference
# Blomkvist, A. W., Eika, F., Rahbek, M. T., Eikhof, K. D., Hansen, M. D., Søndergaard, M., Ryg, J., Andersen, S., & Jørgensen, M. G. (2017). Reference data on reaction time and aging using the Nintendo Wii Balance Board: A cross-sectional study of 354 subjects from 20 to 99 years of age. PLOS ONE, 12(12), e0189598. https://doi.org/10.1371/journal.pone.0189598 1

# Make sure you have an idea of the variable names in the data.
# For example, rt_hand_d means reaction time of hand dominant ("_nd" is for non-dominant).

# Here is a scatterplot: `psyntur` has plotting functions that are built
# around ggplot2 and allow quick plotting. For example try running this line:
scatterplot(data = d_blomkvist, x = rt_hand_d, y = rt_hand_nd)
# What does the plot show you?

#

# Map rt of the dominant hand on the x-axis and rt of the non-dominand
# hand on the y-axis
ggplot(data = blomkvist, mapping = aes(x = ---, y = ---)) +
  geom_point()

# There are some participants with more extreme values.
# Let's see who are those individuals.
# 1. Map rt of dominant hand on the x-axis and rt of non-dominant hand
# on the y-axis (as before).
# 2. Map id on label.
# 3. Replace geom_point() with geom_text() or geom_label().
ggplot(data = blomkvist, mapping = aes(x = ---, y = ---, label = ---)) +
  geom_point()

# It's hard to see the participants on the lower end.
# Use the logarithm for both axis to increase the distance between values
# on the lower end of the scale.
# 1. x and y as previously.
# 2. I've already added scale_y_log10() to log transform the y-axis.
# Do the same for the x-axis.
ggplot(data = blomkvist, mapping = aes(x = ---, y = ---)) +
  geom_point() +
  scale_y_log10() +
  ---

# Replace the points with text or labels (see above).

# Copy the previous code and add a linear model to it, i.e.:
# + stat_smooth(method = "lm")
