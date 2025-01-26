
master_data <- cache_load()

search_coord(long = -101.4656, lat = 51.81913)

x <- search_legal(c("PL-R-St. Andrews"))
map_quarter(x)

x <- search_legal(c("NW-15-11-19W1", "PL-R-St. Andrews", "NE-15-11-19W1"))
map_quarter(x)

t <- master_data |>
  dplyr::rename(legal = "Informal Legal Description") |>
  dplyr::right_join(test, by = dplyr::join_by("legal")) |>
  sf::st_as_sf(coords = c("x", "y"), crs = "EPSG:3857") |>
  sf::st_transform(crs = "+proj=longlat +datum=WGS84")|>
  dplyr::select("legal", "geometry") |>
  sf::st_buffer(t,
                dist = 402,
                endCapStyle = "SQUARE") |>
  dplyr::group_by(legal) |>
  tidyr::nest() |>
  dplyr::mutate(bbox = purrr::map(data, ~sf::st_as_sfc(sf::st_bbox(.x)))) |>
  dplyr::ungroup() |>
  tidyr::unnest(bbox) |>
  sf::st_as_sf() |>
  dplyr::select(-data)


mapview::mapview(t, map.type = "Esri.WorldImagery")


test <- search_coord(long = -98.350505, lat =  49.564319)

map_quarter(test)

d <-test |>
  sf::st_as_sf(coords = c("long", "lat"),crs = "+proj=longlat +datum=WGS84") |>
  sf::st_buffer(dist = 402,
                endCapStyle = "SQUARE")


mapview::mapview(d, map.type = "Esri.WorldImagery")

df <- data.frame(ID = c("a", "b"),
                 long = c(-100.0092, -99.9976),
                 lat = c(49.92703, 49.92703))

df2 <- sf::st_as_sf(df, coords = c("long", "lat"), crs ="+proj=longlat +datum=WGS84") |>
  sf::st_buffer(dist = 402.336,
                endCapStyle = "SQUARE") |>
  dplyr::group_by(ID) |>
  tidyr::nest() |>
  dplyr::mutate(bbox = purrr::map(data, ~sf::st_as_sfc(sf::st_bbox(.x)))) |>
  dplyr::ungroup() |>
  tidyr::unnest(bbox) |>
  sf::st_as_sf() |>
  dplyr::select(-data)
mapview::mapview(df2, map.type = "Esri.WorldImagery")

map_quarter(test) + Polygon


master_data <- cache_load()
x <- search_legal(c("NW-15-11-19W1", "NE-16-11-19W1", "WL-179-Portage La Prairie"))

t <- master_data |>
  dplyr::rename(legal = "Informal Legal Description") |>
  dplyr::right_join(x, by = dplyr::join_by("legal")) |>
  tidyr::drop_na(x | "y") |>
  #dplyr::filter(type == "Quarter") |>
  sf::st_as_sf(coords = c("x", "y"), crs = "EPSG:3857") |>
  sf::st_transform(crs = "+proj=longlat +datum=WGS84") |>
  sf::st_buffer(dist = 402.336,
                endCapStyle = "SQUARE") |>
  sfheaders::sf_boxes() |>
  sf::st_set_crs("+proj=longlat +datum=WGS84") |>
  dplyr::mutate(geometry = dplyr::case_when(type != "Quarter" ~ NA,
                                            TRUE ~ geometry))|>
  dplyr::select("legal", "geometry")

mapview::mapview(t, map.type = "Esri.WorldImagery", zcol = "legal")

map_quarter(x)


df <- data.frame(ID = c("a", "b"),
                 long = c(-100.0092, -99.9976),
                 lat = c(49.92703, 49.92703))

t <- master_data |>
  dplyr::rename(legal = "Informal Legal Description") |>
  dplyr::right_join(test, by = dplyr::join_by("legal")) |>
  sf::st_as_sf(coords = c("x", "y"), crs = "EPSG:3857") |>
  sf::st_transform(crs = "+proj=longlat +datum=WGS84")|>
  dplyr::select("legal", "geometry") |>
  sf::st_buffer(t,
                dist = 402,
                endCapStyle = "SQUARE") |>
  dplyr::group_by(legal) |>
  tidyr::nest() |>
  dplyr::mutate(bbox = purrr::map(data, ~sf::st_as_sfc(sf::st_bbox(.x)))) |>
  dplyr::ungroup() |>
  tidyr::unnest(bbox) |>
  sf::st_as_sf() |>
  dplyr::select(-data)



test <- search_legal(c("SE-16-7-7W1"))

map_quarter(test)


as.data.frame(test)

a <- sf::st_sfc(sf::st_point(c(-98.35192, 49.56579))) %>%
  sf::st_set_crs("+proj=longlat +datum=WGS84")

b <-sf::st_sfc(sf::st_point(c(-98.34661, 49.56224))) %>%
  sf::st_set_crs("+proj=longlat +datum=WGS84")

sf::st_distance(a,b)


test <- search_coord(lat = c(49.56224, 49.560789), long = c(-98.34661, -98.348042))
test
map_quarter(test)


library(sf)
a <- st_polygon()
mapview(a)
