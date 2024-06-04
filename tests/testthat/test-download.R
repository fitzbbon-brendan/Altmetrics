test_that("File downloads properly", {

    # Download the file
    url <- "https://geoportal.gov.mb.ca/api/download/v1/items/11fa11f9015b45438d6493dcb3d8071c/csv?layers=0" # Replace with your file URL
  destfile <- tempfile() # Temporary file location
  download.file(url, destfile)

  # Check if the file exists
  expect_true(file.exists(destfile))
  file_size <- file.info(destfile)$size
  expect_gt(file_size, 100000)

  # Check the file content
  expected_content <- "FID,Informal Legal Description,Formal Legal Description,Type,Quarter,SECTION,TOWNSHIP,RANGE,LOT NO,MERIDIAN,PARISH NAME,RANGEADD,x,y"
  actual_content <- readLines(destfile, n = 1)
  expect_equal(actual_content, expected_content)

  # Clean up: remove the temporary file
  unlink(destfile)
})

test_that ("Cache check is working", {
  expect_silent(q <- cache_check())
  expect_error(cache_check(ask = "yes"), "Argument `ask` must be TRUE or FALSE")
})

test_that ("Cached data is what I think it shoud be", {
  expect_silent(q <- cache_load())
  expect_s3_class(q, "data.frame")
  expect_named(q, c( "FID", "Informal Legal Description", "Formal Legal Description", "Type", "Quarter",  "SECTION", "TOWNSHIP", "RANGE", "LOT NO", "MERIDIAN", "PARISH NAME", "RANGEADD", "x", "y"))
})


test_that ("Messages, warnings, and errors show up", {
  expect_error(quarters_dl(ask = "yes"), "Argument `ask` must be TRUE or FALSE")
})
