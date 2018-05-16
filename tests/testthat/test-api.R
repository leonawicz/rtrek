context("api")

library(dplyr)

test_that("st_book_series returns as expected", {
  expect_is(stapi("character", page_count = TRUE), "NULL")

  d <- stapi("character", page = 2)
  d2 <- stapi("character", page = c(2, 4))
  expect_is(d, "tbl_df")
  expect_is(d2, "tbl_df")
  expect_equal(nrow(d), 100)
  expect_equal(nrow(d2), 200)

  Q <- stapi("character", uid = "CHMA0000025118")
  expect_is(Q, "list")
  expect_equal(Q$character$name, "Q")

  expect_error(stapi("a"), "Invalid `id`.")

  expect_is(stapi_options(), "character")
})
