test_that("search_coord() returns dataframe", {

  expect_silent(q <- search_coord(long = -101.4656, lat = 51.81913))
  expect_s3_class(q, "data.frame")
  expect_named(q, c("legal", "long", "lat", "dist"))
  expect_equal(q,
               tibble::tribble(
                 ~legal,           ~long,      ~lat,      ~dist,
                 "NE-11-33-29W1",   -101.4656,  51.81913,   48.39339) |>
                 dplyr::mutate(dist = units::set_units(dist, m)), tolerance = TRUE
  )

})



test_that ("Messages, warnings, and errors show up", {
  expect_error(search_coord(long = -102.4660, lat = 51.83500), "One or more coordinates greater than 1000m from nearest quarter section center. Please check your data.")
  expect_warning(search_coord(long = -101.579544, lat = 51.818954), "One or more coordinates greater than 600m from nearest quarter section center. Please check your data.")
  expect_error(search_coord(long = "test", lat = 51.83500), "Longitude and latitude must be numbers.")
  expect_error(search_coord(long = -102.4660, lat = "test"), "Longitude and latitude must be numbers.")
  expect_error(search_coord(long = -102.4660, lat = c(51.83500, 51.81913)), "Number of longitude and latitude coordinates must be equal.")
})

