## code to prepare `mbquartR_example` dataset goes here

mbquartR_example <- cache_load() |>
  dplyr::filter(`Formal Legal Description` %in%
                  c("NE-11-033-29W1", "SW-20-002-01W1", "NW-15-011-19W1",
                    "NE-01-012-12E1"))

usethis::use_data(mbquartR_example, overwrite = TRUE)
