# dygraphs ########################

# install.packages("dygraphs")
library(dygraphs)

# Turn into time series
times <- paste0(counts$date, " ", counts$hour, ":00 UTC") %>% as.POSIXct()
ts_times <- xts(counts$n, order.by = times, frequency = 24)

# Plot using dygraph
dg <- dygraph(ts_times) %>%
  dyAxis("y", "Downloads") %>%
  dyAxis("x", "Date")
dg

dg %<>% dyRangeSelector() %>% dyAnnotation(as.POSIXct("2015-05-17 19:00"), "A") %>%
  dyShading(as.POSIXct("2015-05-17 05:00"),
    as.POSIXct("2015-05-18 09:00")) %>%
  dyRoller()
dg


# networkD3 ##########

# install.packages("networkD3")
library(networkD3)

# Load data
data(MisLinks)
data(MisNodes)

# Plot
forceNetwork(Links = MisLinks, Nodes = MisNodes,
  Source = "source", Target = "target",
  Value = "value", NodeID = "name",
  Group = "group", opacity = 0.8)


## Leaflet ###################

# install.packages("leaflet")
library(leaflet)
leaflet(quakes) %>%
  addTiles("//{s}.tiles.mapbox.com/v3/mapbox.natural-earth-2/{z}/{x}/{y}.png") %>%
  addCircles(color = "#CC0000", weight = 2, radius = ~10^mag / 5,
    popup = ~as.character(stations))


## threejs globe ############

# install.packages("threejs")
library(threejs)
globejs(lat = quakes$lat, long = quakes$long, value = 10^quakes$mag / 10^4,
  atmosphere = TRUE)


# epiwidgets ################

# devtools::install_github("sdwfrost/epiwidgets")
library(epiwidgets)

nwk <- "(((EELA:0.150276,CONGERA:0.213019):0.230956,(EELB:0.263487,CONGERB:0.202633):0.246917):0.094785,((CAVEFISH:0.451027,(GOLDFISH:0.340495,ZEBRAFISH:0.390163):0.220565):0.067778,((((((NSAM:0.008113,NARG:0.014065):0.052991,SPUN:0.061003,(SMIC:0.027806,SDIA:0.015298,SXAN:0.046873):0.046977):0.009822,(NAUR:0.081298,(SSPI:0.023876,STIE:0.013652):0.058179):0.091775):0.073346,(MVIO:0.012271,MBER:0.039798):0.178835):0.147992,((BFNKILLIFISH:0.317455,(ONIL:0.029217,XCAU:0.084388):0.201166):0.055908,THORNYHEAD:0.252481):0.061905):0.157214,LAMPFISH:0.717196,((SCABBARDA:0.189684,SCABBARDB:0.362015):0.282263,((VIPERFISH:0.318217,BLACKDRAGON:0.109912):0.123642,LOOSEJAW:0.397100):0.287152):0.140663):0.206729):0.222485,(COELACANTH:0.558103,((CLAWEDFROG:0.441842,SALAMANDER:0.299607):0.135307,((CHAMELEON:0.771665,((PIGEON:0.150909,CHICKEN:0.172733):0.082163,ZEBRAFINCH:0.099172):0.272338):0.014055,((BOVINE:0.167569,DOLPHIN:0.157450):0.104783,ELEPHANT:0.166557):0.367205):0.050892):0.114731):0.295021)"
treewidget(nwk)


# streamgraph ###############

# devtools::install_github("hrbrmstr/streamgraph")

library(streamgraph)
library(dplyr)

ggplot2::movies %>%
  select(year, Action, Animation, Comedy, Drama, Documentary, Romance, Short) %>%
  tidyr::gather(genre, value, -year) %>%
  group_by(year, genre) %>%
  tally(wt=value) -> dat

streamgraph(dat, "genre", "n", "year", interactive=TRUE) %>%
  sg_axis_x(20, "year", "%Y") %>%
  sg_fill_brewer("PuOr")


# parcoords ###############

# devtools::install_github("timelyportfolio/parcoords")

library(parcoords)

parcoords(mtcars, reorderable = T, brushMode = "1D-axes")







## Shiny #############

library(shiny)
library(leaflet)

source("dialogpage.R")

ui <- dialogPage(padding = 0,
  leafletOutput("map", height = "100%")
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet(quakes) %>%
      addTiles("//{s}.tiles.mapbox.com/v3/mapbox.natural-earth-2/{z}/{x}/{y}.png") %>%
      addCircles(color = "#CC0000", weight = 2, radius = ~10^mag / 5,
        popup = ~as.character(stations))
  })
}

shinyApp(ui, server)


