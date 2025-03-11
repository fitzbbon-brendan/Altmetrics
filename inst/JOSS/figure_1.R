library(mbquartR)
library(ggplot2)
library(mapview)

location <- data.frame(
  lat = c(49.356048, 49.372180),
  long = c(-98.304846, -98.254691),
  sample_id = factor(seq(1, 2, 1)))
location

location_2 <- search_coord(lat = location$lat, long = location$long)
location_2

mapviewOptions(fgb = FALSE)
map <- map_quarter(location_2)
map


mapshot(map, file = here::here("./inst/JOSS/figure_1.png"),
        remove_controls = NULL)

