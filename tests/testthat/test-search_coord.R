test_that("search_coord() returns dataframe", {

  expect_silent(q <- search_coord(long = -101.4656, lat = 51.81913))
  expect_s3_class(q, "data.frame")
  expect_named(q, c("legal", "type", "long", "lat", "long_user",
                    "lat_user", "dist"))
  expect_equal(q,
               tibble::tribble(
                 ~legal,          ~type,     ~long,      ~lat,     ~long_user,
                 ~lat_user, ~dist,
                 "NE-11-33-29W1", "Quarter", -101.4653,  51.81893, -101.4656,
                 51.81913,  29.93141) |>
                 dplyr::mutate(dist = units::set_units(dist, m)),
               tolerance = 0.001
  )

})



test_that ("Messages, warnings, and errors show up", {
  expect_error(search_coord(long = -94.124673, lat =  52.197803),
               "One or more coordinates greater than 1000m")
  expect_warning(search_coord(long = -95.147666, lat = 51.901422),
                 "One or more coordinates greater than 600m")
  expect_error(search_coord(long = "test", lat = 51.83500),
               "Longitude and latitude must be numbers.")
  expect_error(search_coord(long = -100.4660, lat = "test"),
               "Longitude and latitude must be numbers.")
  expect_error(search_coord(long = -100.4660, lat = c(51.83500, 51.81913)),
               "Number of longitude and latitude coordinates must be equal.")
  expect_error(search_coord(long = -103.4660, lat = 51.83500),
               "Longitude values must be between -102.0 and -88.94.")
  expect_error(search_coord(long = -100.4660, lat = 48.83500),
               "Latitude values must be between 49.0 and 60.0.")
})

