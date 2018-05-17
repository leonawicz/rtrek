context("api")

library(dplyr)

test_that("st_book_series returns as expected", {
  expect_is(stapi("character", page_count = TRUE), "NULL")

  d <- stapi("character", page = 2)
  d2 <- stapi("character", page = c(2, 4))
  d3 <- stapi("character", page = 1)
  purrr::walk(list(d, d2, d3), ~expect_is(.x, "tbl_df"))
  purrr::walk(list(d, d2, d3), c(100, 200, 100), ~expect_equal(nrow(.x), .y))

  Q <- stapi("character", uid = "CHMA0000025118")
  expect_is(Q, "list")
  expect_equal(Q$character$name, "Q")

  expect_error(stapi("a"), "Invalid `id`.")

  expect_is(stapi_options(), "character")
})

test_that("rtrek_antiddos option is set on load and checked", {
  expect_equal(getOption("rtrek_antiddos"), 1)
  options(rtrek_antiddos = 0)
  wrn <- "`rtrek_antiddos` setting in `options` is less than one and will be ignored.\n"
  expect_warning(stapi("character", page = 2), wrn)
  options(rtrek_antiddos = 1)
})
