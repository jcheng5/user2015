library(dplyr)
library(d3heatmap)
library(dygraphs)
library(xts)

downloads <- do.call(rbind, lapply(list.files("data", full.names = TRUE), read.csv, stringsAsFactors=FALSE))

counts <- downloads %>% mutate(hour=sub(":.*", "", time)) %>%
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
