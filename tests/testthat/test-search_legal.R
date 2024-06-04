test_that("search_legal() returns dataframe", {

  expect_silent(q <- search_legal(x = "NE-11-33-29W"))
  expect_s3_class(q, "data.frame")
  expect_named(q, c("legal", "long", "lat"))
  expect_equal(q,
               tibble::tribble(
                 ~legal,           ~long,      ~lat,
                 "NE-11-33-29W1",   -101.4656,  51.81913), tolerance = TRUE
  )

})

test_that ("Messages, warnings, and errors show up", {
  expect_warning(search_legal(x = c("NE-11-33-29W", "SW-20-2-1x")), "One or more of the legal land descriptions could not be found. Please check your data.")
  expect_warning(search_legal(x = "NE-2-12-12E"), "One or more of the legal land descriptions has an ambiguous meridian value E and is assumed to be east of prime meridian \\(E1\\). \nTo stop messages please specify meridians as E1 or E2 \\(e.g., NW-36-89-11E1\\).")
  expect_error(search_legal(x = 5), "Legal land descriptions must be text.")
})


