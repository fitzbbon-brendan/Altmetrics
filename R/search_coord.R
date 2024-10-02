#' Search for the nearest quarter section using latitude and longitude
#'
#' Find the quarter section(s) closest to provided coordinates. Returns the
#' legal land description
#'
#' @param long Longitude in decimal degrees
#' @param lat Latitude in decimal degrees
#'
#' @return A tibble of the latitude and longitude coordinates, corresponding
#' legal land descriptions, and distance in metres from the provided
#' coordinates to the centre of the closest quarter section
#'
#' @export
#'
#' @examples
#' search_coord(long = c(-101.4656, -99.99768), lat = c(51.81913, 49.928926))
#' x <- data.frame(long = c(-101.4656, -99.9976), lat = c(51.81913, 49.92892))
#' search_coord(long = x$long, lat = x$lat)


search_coord <- function(long, lat) {

  if(!is.numeric(long) || !is.numeric(lat))
  stop("Longitude and latitude must be numbers.")

  if(length(long) != length(lat))
  stop("Number of longitude and latitude coordinates must be equal.")

  master_data <- cache_load()
  search_df <- tibble::tibble(long = long, lat = lat) |>
    sf::st_as_sf(coords = c("long", "lat"),
                 crs = "+proj=longlat +datum=WGS84") |>
    sf::st_transform(crs = "EPSG:3857") |>
    dplyr::mutate(coords = as.data.frame(
      sf::st_coordinates(.data[["geometry"]]))) |>
    tidyr::unnest("coords") |>
    sf::st_drop_geometry() |>
    tibble::rowid_to_column("point") |>
    dplyr::mutate(dist = purrr::map2(
      .data[["X"]], .data[["Y"]],
      \(x, y) closest_centroid(master_data, x, y))) |>
    tidyr::unnest("dist") |>
    dplyr::mutate(dist = units::set_units(.data[["dist"]], "m")) |>
    dplyr::select("point", legal = "Informal Legal Description", "dist") |>
    dplyr::left_join(tibble::tibble(long = long, lat = lat) |>
                       tibble::rowid_to_column("point"), by = "point") |>
    dplyr::select(-"point") |>
    dplyr:: relocate("dist", .after = dplyr::last_col())

  if(max(as.numeric(search_df$dist)) >= 1000)
    stop("One or more coordinates greater than 1000m from nearest quarter",
         " section center. Please check your data.")

  if(max(as.numeric(search_df$dist)) > 600 && max(as.numeric(search_df$dist))
     < 1000)
    warning("One or more coordinates greater than 600m from nearest quarter",
            " section center. Please check your data.")
  search_df
}



closest_centroid <- function(master_data, X, Y) {
  master_data |>
    dplyr::bind_cols(X = X, Y = Y) |>
    dplyr::mutate(dist = ((X - .data[["x"]])^2 + (.data[["y"]] - Y) ^2)^0.5) |>
    dplyr::filter(.data[["dist"]] == min(.data[["dist"]])) |>
    dplyr::select(-X, -Y)
}


