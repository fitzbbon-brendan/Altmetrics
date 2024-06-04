#' Finding Manitoba, Canada, quarter sections made easier
#'
#' \code{mbquartR} is an R package for locating quarter sections in Manitoba using lat/long coordinates
#' or the legal land descriptions using the  Manitoba Original Survey Legal Descriptions data set from the Data MB website (<https://geoportal.gov.mb.ca/>)

#' There are four main functions in this package:
#'
#' 1. Download the Manitoba Original Survey Legal Descriptions data set
#'     - [`quarters_dl()`]
#'
#'  2. Search for legal land descriptions using lat and long coordinates
#'    - [`search_coord()`]
#'
#'  3. Search lat and long coordinates for using legal land descriptions
#'    - [`weather_interp()`]
#'
#'  4. Plot search results on an interactive map
#'    - [`map_quarter()`]
#'

#' @docType package
#' @name mbquartR-package
#' @aliases mbquartR mbquartR-package
#' @importFrom rlang .data

NULL

# Dealing with CRAN Notes due to Non-standard evaluation
.onLoad <- function(libname = find.package("mbquartR"),
                    pkgname = "mbquartR"){

# CRAN Note avoidance
if(getRversion() >= "2.15.1")
  utils::globalVariables(
    # Vars used in Non-Standard Evaluations, declare here to
    # avoid CRAN warnings
    c(".", " " # piping requires '.' at times
    )
  )
invisible()
}
