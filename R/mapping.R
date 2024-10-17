
#' Quickly find MB quarter sections on a map
#'
#' Plot the output of `search_legal()` or `search_coord()` or similar
#' dataframe onto an interactive Leaflet map
#'
#' @details Data frame must include the following three column names:
#'
#' 1. `legal` - A character that specifies the legal land description
#' (NE-11-33-29W1)
#' 2. `long` - A numeric specifying the longitude in decimal degrees (-97.6)
#' 3. `lat` - A numeric specifying the latitude in decimal degrees (49.1)
#'
#' @param x Output from `search_legal()` or `search_coord()` or similar
#' dataframe
#' @param map.type Base map: see
#' <https://leaflet-extras.github.io/leaflet-providers/preview/> for available
#' options
#'
#' @return A Leaflet map
#' @export
#'
#' @examples
#' search1 <- search_legal(x = c("NE-11-33-29W1", "SW-20-2-1W1"))
#' map_quarter(x = search1)
#' search2 <- search_coord(long = c(-101.4656, -99.99768),
#' lat = c(51.81913, 49.928926))
#' map_quarter(x = search2)
map_quarter <- function(x, map.type = "Esri.WorldImagery") {

  if (!is.data.frame(x)) stop("Must provide a dataframe")
  if(!"legal" %in% names(x)) stop("Dataframe must have a coloumn named legal")

  Centre <- centroid(x)

  if(nrow(x) > nrow(Centre))
  warning("One or more of the legal land descriptions could not be found.",
          " Please check your data.")

  mapview::mapview(Centre, map.type = map.type, homebutton = FALSE)
}

#' Find centre coordinates
#'
#' Finds the center coordinates for the supplied legal land description.
#'
#' @param x Output from `search_legal()` or `search_coord()` or similar
#'   dataframe
#'
#' @return Tibble. Simple feature collection with legal land description and
#'   associated point geometry
#'
#' @noRd
centroid <- function(x) {
  cache_load() |>
    dplyr::rename(legal = "Informal Legal Description") |>
    dplyr::right_join(x, by = dplyr::join_by("legal")) |>
    tidyr::drop_na(x | "y") |>
    sf::st_as_sf(coords = c("x", "y"), crs = "EPSG:3857") |>
    sf::st_transform(crs = "+proj=longlat +datum=WGS84") |>
    dplyr::select("legal", "geometry")
}


