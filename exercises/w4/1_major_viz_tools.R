---
title             : 'Exercise 2c: Aesthetics and attributes'
output            : html_document
---


```{r setup, include=FALSE}
# No need to run this chunk unless you're "knitting"
knitr::opts_chunk$set(echo = TRUE,
                      comment= NA, 
                      warning = FALSE,
                      message = FALSE)
```


Load `tidyverse` package using the `library` function.

```{r}
# Load tidyverse
library(tidyverse)
```


Load our data. 

```{r}
# Load the data
d_blomkvist <- read_csv("../../data/blomkvist.csv")

# Remove missing category for smoker and missing values for rt
d_blomkvist <- drop_na(d_blomkvist, smoker, rt_hand_d)
```


Let's practice combining aesthetics and attributes in one plot. The final plot will be violating some principles of data visualisation but the end justifies the means. This is for practice only.

First, run the plot to see what it shows, before we add aesthetics and attributes to a copy of this plot below.

```{r}
ggplot(d_blomkvist, aes(x = smoker, y = rt_hand_d)) +
  geom_point() +
  geom_boxplot(outliers = FALSE) 
```

This is a boxplot with dots for data. Boxplots illustrate descriptive information such as the median (we will return to these in a later session).

What we want to achieve next is 

- to add another categorical variable to this plot (i.e. the sex of the participants). 
- to jitter the position of the dots while ensuring that the dots are group by sex.
- to make sure that we can see the dots behind the boxes.

For the code below, I have already added a position argument. `position_jitterdodge` works with aesthetics for categorical variables and will ensure that the dots are "dodged" so that they appear behind their respective boxes, and "jittered" so that there is some random noise added to their horizontal location so the dots don't appear all in one line (which causes overplotting).

Your **task** is to separate data by sex by creating aesthetics mappings so that the dots appear in different shapes and the boxes appear with differently coloured outlines and filled with different coloured. The dots should remain black. To reduce overplotting make the dots smaller (size 2) and reduce the opacity to .5. Also reduce the opacity of the boxes to .25 so that we can see what's going on behind the boxes. 

```{r}
ggplot(d_blomkvist, aes(x = smoker, y = rt_hand_d)) +
  geom_point(---
    position = position_jitterdodge(jitter.width = .25, dodge.width = .75)) +
  geom_boxplot(---, outliers = FALSE) 
```

Convince yourself that the resulting plot has all features described in the text above. 



Once you've completed all tasks above you can `knit` this document to HTML.


