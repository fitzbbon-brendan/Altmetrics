
#' Quickly find MB quarter sections on a map
#'
#' @param x Output from `search_legal()` or `search_coord()` or similar dataframe
#' @param map.type Base map: see <https://leaflet-extras.github.io/leaflet-providers/preview/> for available options
#'
#' @return A tibble of latitude and longitude coordinates
#' @export
#'
#' @examples
#' search1 <- search_legal(x = c("NE-11-33-29W1", "SW-20-2-1W1"))
#' map_quarter(x = search1)
#' search2 <- search_coord(long = c(-101.4656, -99.99768), lat = c(51.81913, 49.928926))
#' map_quarter(x = search2)
map_quarter <- function(x, map.type = "Esri.WorldImagery") {

  if (!is.data.frame(x)) stop("Must provide a dataframe")
  if(!"legal" %in% names(x)) stop("Dataframe must have a coloumn named legal")

  Centre <- centroid(x)

  if(nrow(x) > nrow(Centre)) warning("One or more of the legal land descriptions could not be found. Please check your data.")

  mapview::mapview(Centre, map.type = map.type, homebutton = FALSE)
}

centroid <- function(x) {
  cache_load() |>
    dplyr::rename(legal = "Informal Legal Description") |>
    dplyr::right_join(x, by = dplyr::join_by("legal")) |>
    tidyr::drop_na(x | "y") |>
    sf::st_as_sf(coords = c("x", "y"), crs = "EPSG:3857") |>
    sf::st_transform(crs = "+proj=longlat +datum=WGS84") |>
    dplyr::select("legal", "geometry")
}


