library(dplyr)
library(d3heatmap)
library(dygraphs)
library(xts)
library(reshape2)

downloads <- do.call(rbind, lapply(list.files("data", full.names = TRUE), read.csv, stringsAsFactors=FALSE))
downloads <- downloads %>% mutate(hour=sub(":.*", "", time))

counts <- downloads %>%
  filter(country %in% c("US")) %>%
  count(date, hour) %>%
  arrange(date, hour)


# dygraphs ########################
times <- paste0(counts$date, " ", counts$hour, ":00 UTC") %>% as.POSIXct()
ts_times <- xts(counts$n, order.by = times, frequency = 24)
dygraph(ts_times)


# d3heatmap #######################

m_counts <- matrix(counts$n, length(unique(counts$hour)), length(unique(counts$date)))
colnames(m_counts) <- unique(counts$date) %>% sub("2015-(\\d+)-", "\\1/", .)
rownames(m_counts) <- unique(counts$hour)
m_counts["08","06/22"] <- NA

d3heatmap(t(m_counts), colors = "Greens", dendrogram = "none", scale = "none")

major_countries <- downloads %>% count(country) %>% filter(n > 100) %>% `$`("country")
hours_countries <- downloads %>%
  filter(country %in% major_countries) %>%
  count(hour, country) %>%
  arrange(hour, country)
m_hours_countries <- acast(hours_countries, hour ~ country, value.var = 'n')
m_hours_countries[is.na(m_hours_countries)] <- 0

d3heatmap(m_hours_countries, colors = "Blues", dendrogram = "col", scale = "col")
d3heatmap(scale(m_hours_countries), colors = "Blues", dendrogram = "col", scale = "col")
