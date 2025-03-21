library(tidyverse)
library(ggspatial)
library(sf)

mb <- rnaturalearth::ne_states(c("canada"), returnclass = "sf") 

library(mbquartR)

as.data.frame(search_legal("SE-22-10-19W1"))

area_thresh <- units::set_units(100000, km^2)

test <- mb |>
  filter(name == "Manitoba") 

test2 <- st_cast(test,"POLYGON")

test <- test2[1,] |>
  smoothr::fill_holes(threshold = area_thresh)

p <- ggplot () +
  theme_void() +
  layer_spatial(test, fill = "white", linewidth = 0.5) +
  geom_rect(aes(xmin = -94.5, xmax = -101, ymin = 54.5, ymax = 58), color = "#2E7D32", fill = NA, linewidth = 0.5) +
  geom_rect(aes(xmin = -97.75, xmax = -101, ymin = 54.5, ymax = 56.25), color = "#2E7D32", fill = "#2E7D32", alpha = 0.5, linewidth = 0.5) +
  geom_point(aes(x = -99.375, y = 55.375), colour = "black", fill = "black", size = 1) +
  geom_rect(aes(xmin = -94.5, xmax = -97.75, ymin = 54.5, ymax = 58), color = "#2E7D32", fill = NA, linewidth =0.5) +
  geom_rect(aes(xmin = -94.5, xmax = -97.75, ymin = 54.5, ymax = 56.25), color = "#2E7D32", fill = NA, linewidth =0.5) +
  #annotate("text", x = -98.375, y = 55.875, label = "SE-22-10-19W1") +
  annotate("text", x = -102.8, y = 49.5, label = "SE-22-10-19W1", hjust = 0.04, vjust = 1.05, angle = 93, size = 5.5) +
  geom_point(aes(x = -99.96777, y = 49.84601), colour = "#2E7D32", fill = "#2E7D32", shape = 22)
p

library(hexSticker)
sticker(p, package = "mbquartR", p_size = 20, 
        s_x = 1.14, s_y = 0.75, 
        p_x = 1, p_y = 1.54,
        s_width = 1.29, s_height = 1.29,
        h_fill="#2E7D32", h_color = "black")


