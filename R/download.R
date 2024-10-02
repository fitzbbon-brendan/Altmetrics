#' Download the MB quarter section data
#'
#' Downloads the full list of quarter sections and coordinates from the
#' Manitoba Geoportal. Note that when the Geoportal is unavailable, data is
#' downloaded from an archived version from the package repository on Github.
#'
#' This data set should be static.
#'
#' @param force Logical. If TRUE, forces a re-download of the data. Note this
#' data shouldn't require regular (or any) updates.
#' @param ask Logical. If TRUE, asked to create the cache folder for
#' MB quarter section data
#' @param quiet Logical. If TRUE, suppresses status messages while downloading
#'  the data
#'
#' @return Nothing. But has the side effect of downloading a .csv file of
#'   Manitoba Original Survey Legal Descriptions and coordinates to the cache
#'   folder (`cache_dir()`).
#'
#' @export
#'
#' @examples \dontrun{
#' quarters_dl()
#' }
#'
quarters_dl <- function(force = FALSE, ask = TRUE, quiet = FALSE) {

  # Checks
  cache_check(ask)

  # Filename
  mb_quarters <- cache_file()

  # Skip if file exists
  if (!force && file.exists(mb_quarters)) {
    message(crayon::blue("File exists, skipping download. Use `force = TRUE`",
                         " to force download."))
    return(invisible())
  }
  cache_dl(quiet = quiet)
}

#' Check that data cache directory exists, create if not
#'
#' @examples \dontrun{
#' cache_check()
#' }
#' @noRd
cache_check <- function(ask = TRUE) {

  if (!is.logical(ask)) stop("Argument `ask` must be TRUE or FALSE")

  d <- cache_dir()

  if(ask && !dir.exists(d)) {
    question_dl <- utils::menu(choices = c("Yes", "No"),
                               title = paste0("Would you like to create the ",
                                              "cache folder for MB quarter ",
                                              "section data at\n", d))
    if (question_dl == 2) stop("Cannot create cache folder without permission")
  }

  dir.create(d, recursive = TRUE, showWarnings = FALSE)
}


#' Check whether data file exists
#'
#' @noRd
cache_file_check <- function() {
  if(!file.exists(cache_file())){
    stop("Data does not exist, please download with `quarters_dl()` first",
         call. = FALSE)
  }
}

cache_dl <- function(quiet = FALSE) {

  # Get the Geoportal URL
  url <- getOption("mbquartR_dl_url")
  if(is.null(url)) {
    url <- file.path("https://geoportal.gov.mb.ca/api/download/v1/items/",
                     "11fa11f9015b45438d6493dcb3d8071c/csv?layers=0")
  }

  if(!url_ok(url)) {
    url <- getOption("mbquartR_dl_url_backup")
    if(is.null(url)) {
      url <- file.path("https://github.com/alex-koiter/mbquartR/releases/",
                       "download/data-backup/mb_quarters.csv")
    }
    message("Data from geoportal.gov.mb.ca is not currently available, using",
            " backup data source.\n", "See ?quarters_dl for more details.")
  }

  utils::download.file(url, destfile = file.path(cache_dir(),"mb_quarters.csv"),
                       quiet = quiet)
  if(file.exists(cache_file())) {
    message(crayon::blue("You have downloaded the data to", cache_file()))
  } else {
    stop("Could not find downloaded data please try again")
  }
}

url_ok <- function(url) {
  h <- curlGetHeaders(url, timeout = 20)
  attr(h, "status") == 200
}

cache_file <- function(check = FALSE) {
  file.path(cache_dir(), "mb_quarters.csv")
}

cache_dir <- function() {
  d <- getOption("mbquartR_cache_dir")
  if(is.null(d)) d <- tools::R_user_dir("mbquartR")
  d
}

cache_load <- function() {

  if(!is.null(getOption("mbquartR_example")) && getOption("mbquartR_example")) {
    #message("Using mini example data")
    return(mbquartR::mbquartR_example)
  } else {

    cache_file_check()
    readr::read_csv(cache_file(), guess_max = 20000, show_col_types = FALSE,
                    progress = FALSE)
  }
}

