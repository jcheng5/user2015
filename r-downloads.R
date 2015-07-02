# Setup ###########################

library(dplyr)
library(gplots)
library(xts)
library(reshape2)
library(tidyr)

# Slurp up ./data/*.csv into one data frame
downloads <- do.call(rbind, lapply(list.files("data", full.names = TRUE), read.csv, stringsAsFactors = FALSE))
# Round time to nearest hour
downloads <- downloads %>% mutate(hour = sub(":.*", ":00", time)) %>% tbl_df()

# Counts per date/hour by country
counts_by_country <- downloads %>%
  count(date, hour, country) %>%
  arrange(date, hour, country)
View(counts_by_country)

# Counts per date/hour, all countries combined
counts <- counts_by_country %>%
  group_by(date, hour) %>%
  summarise(n = sum(n))
View(counts)

# Countries with at least 300 downloads
major_countries <- (downloads %>% count(country) %>% filter(n > 300))$country

# Make a matrix of countries vs. hours
m_hours_countries <- counts_by_country %>%
  filter(country %in% major_countries) %>%
  group_by(hour, country) %>%
  summarise(n = sum(n)) %>%
  arrange(hour, country) %>%
  acast(hour ~ country, value.var = 'n', fill = 0)


# heatmap #########################

library(d3heatmap)

m_counts <- t(acast(counts, date ~ hour, value.var = 'n'))

heatmap(m_counts)
d3heatmap(m_counts)

d3heatmap(m_hours_countries, colors = "Blues", dendrogram = "col", scale = "none")
d3heatmap(m_hours_countries, colors = "Blues", dendrogram = "col", scale = "col")
d3heatmap(scale(m_hours_countries), cellnote = m_hours_countries,
  colors = "Blues", dendrogram = "col", scale = "col")
