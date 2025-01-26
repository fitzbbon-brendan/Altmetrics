
#' Search for the coordinates of MB quarter sections
#'
#' Find the centre coordinates of quarter sections and other legal division
#' types using the legal land description.
#'
#' @details A legal land description for a quarter section consists of four
#' values separated by a -
#' 1. Quarter Section (SW)
#' 2. Section (9)
#' 3. Township (8)
#' 4. Range (6E1)
#'
#' For example:
#' A legal land description of SW-9-8-6E1 can be interpreted as the Southwest
#' Quarter of Section 9, Township 8, Range 6 East of the 1st Meridian.
#'
#' `search_legal()` takes legal land descriptions and locates the centre
#' coordinates of the quarter sections. You can include leading zeroes
#' (e.g., NE-01-012-12E1) or not (e.g., NE-1-12-12E1). The data set used in
#' this package includes three meridians (W1, E1, and E2); however, most
#' commonly searched for quarter sections use the East 1 (E1) or West 1 (W1)
#' meridians. If the meridian number is not included it will default to 1.
#' For example, a search for NW-36-89-11E will by default search for
#' NW-36-89-11E1 despite NW-36-89-11E2 existing in the data set.
#'
#' Other land division types can have different naming conventions and include:
#'  - RL = River lot (e.g., RL-11-Oak Island)
#'  - Lot = Township lot (e.g., 10-54-27W1)
#'  - OT = Outer two mile lot (e.g., OT-11A-St. Clements)
#'  - PL = Parish lot (e.g., PL-R-St. Andrews)
#'  - SL = Settlement lot (e.g., SL-2-Roman Catholic Mission Property)
#'  - WL = Wood lot (e.g., WL-179-Portage La Prairie)
#'
#' @param x Character. Vector of quarter section legal land descriptions you
#' wish to search for.
#'
#' @return A tibble of legal land descriptions, division type, and
#' corresponding latitude and longitude coordinates.
#' @export
#'
#' @examples
#' search_legal(x = c("NE-11-33-29W", "SW-20-2-1W"))

search_legal <- function(x) {

  if(!is.character(x)) stop("Legal land descriptions must be text.")
  if(any(stringr::str_detect(x, "E$")))
    warning(
      "One or more of the legal land descriptions has an ambiguous ",
      "meridian value E and is assumed to be east of prime meridian (E1).",
      "\nTo stop messages please specify meridians as E1 or E2 ",
      "(e.g., NW-36-89-11E1).")

  search <- x |>
    stringr::str_replace_all("\\b0+","") |> ## Remove leading zeros
    stringr::str_replace("E$", "E1") |> ## Assumes E is E1 and not E2
    stringr::str_replace("W$", "W1") ## Only one western meridian in MB W1

  df_legal <- cache_load() |>
    dplyr::filter(.data[["Informal Legal Description"]] %in% search)

  if(nrow(df_legal) == 0)
    stop("No matches found for the legal land descriptions provided")

  df_legal <- df_legal |>
    sf::st_as_sf(coords = c("x", "y"), crs = "EPSG:3857") |>
    sf::st_transform(crs = "+proj=longlat +datum=WGS84") |>
    dplyr::mutate(coords = as.data.frame(
      sf::st_coordinates(.data[["geometry"]]))) |>
    tidyr::unnest("coords") |>
    sf::st_drop_geometry() |>
    dplyr::select(legal = "Informal Legal Description",
                  type = "Type",
                  long = "X", lat = "Y") |>
    tibble::tibble()

  if(length(x) > length(df_legal$legal))
    warning("One or more of the legal land descriptions could not be found.",
            " Please check your data.")
  df_legal
}

