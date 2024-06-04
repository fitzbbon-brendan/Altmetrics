
test_that("map_quarter() returns a map", {
  library(mapview)
  expect_silent(q <- map_quarter(x = data.frame("legal" = "SW-6-35-29W1")))
  expect_s4_class(q, "mapview")
})

test_that ("Messages, warnings, and errors show up", {
  expect_error(map_quarter(x = c("SW-6-35-29W1", "NW-7-33-29W1")), "Must provide a dataframe")
  expect_error(map_quarter(x = data.frame("Location" = c("SW-6-35-29W1", "test"))), "Dataframe must have a coloumn named legal")
  expect_warning(map_quarter(x = data.frame("legal" = c("SW-6-35-29W1", "test"))), "One or more of the legal land descriptions could not be found. Please check your data.")
})
