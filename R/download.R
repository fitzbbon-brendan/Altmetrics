# https://services.arcgis.com/mMUesHYPkXjaFGfS/arcgis/rest/services/MB_LegalDesc/FeatureServer/replicafilescache/MB_LegalDesc_-2210306150010260884.csv

# https://geoportal.gov.mb.ca/api/download/v1/items/11fa11f9015b45438d6493dcb3d8071c/csv?layers=0
#https://geoportal.gov.mb.ca/api/download/v1/items/11fa11f9015b45438d6493dcb3d8071c/shapefile?layers=0

#' Download the MB quarter section data
#'
#' @param force Whether to force a download of the data
#' @param ask Whether to ask to create the cache folder for MB quarter section data
#'
#' @return A .csv file of Manitoba Original Survey Legal Descriptions and coordinates
#' @export
#'
#' @examples \dontrun{
#' quarters_dl()
#' }
#'
quarters_dl <- function(force = FALSE, ask = TRUE) {

  # Checks
  cache_check(ask)

  # Filename
  mb_quarters <- cache_file()

  # Skip if file exists
  if (!force && file.exists(mb_quarters)) {
    message(crayon::blue("File exists, skipping download. Use `force = TRUE` to force download"))
    return(invisible())
  }
  cache_dl()
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
      title = paste0("Would you like to create the cache folder for MB quarter section data at\n",
             d))
    if (question_dl == 2) stop("Cannot create cache folder without permission")
  }

  dir.create(d, recursive = TRUE, showWarnings = FALSE)
}


cache_dl <- function() {
  download.file <- NULL
  download.file("https://geoportal.gov.mb.ca/api/download/v1/items/11fa11f9015b45438d6493dcb3d8071c/csv?layers=0",
                destfile = file.path(cache_dir(),"mb_quarters.csv"))
  if(file.exists(cache_file())) {
    message(crayon::blue("You have downloaded the data to", cache_file()))
  } else {
    stop("Could not find downloaded data please try again")
  }
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
  f <- cache_file()
  if(file.exists(f))
    readr::read_csv(f, guess_max = 20000, show_col_types = FALSE, progress = FALSE)
  else
  stop(message(crayon::blue("Data doesn't exist, please download with `quarters_dl()` first")))
}

