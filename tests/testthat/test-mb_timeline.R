context("mb_timeline")

unavail <- "Internet resources currently unavailable."
soc <- !has_internet("http://memory-beta.wikia.com/")

err1 <- paste("`x` must be numeric years, e.g., 2371:2374, or character decade,",
              "e.g. '2370s', or one of 'main', 'past', 'future' or 'complete'.")
err2 <- "`x` can only be a vector for numeric years. Charatcer options must be scalar."
err3 <- "`x` must be in the range '1900s' - '2490s'. For distant past or future use x = 'past' or x = 'future'."
events <- c("period", "id", "date", "notes")
stories <- c("title", "title_url", "colleciton", "collection_url", "section",
             "context", "series", "date", "media", "notes", "image_url")

test_that("mb_timeline errors as expected", {
  expect_error(mb_timeline("a"), err1)
  expect_error(mb_timeline(c("a", "b")), err2)
  expect_error(mb_timeline("1890s"), err3)
})

test_that("mb_timeline returns as expected (CRAN)", {
  if(soc) skip(unavail)
  skip_on_cran()
  x <- mb_timeline(2360)
  expect_is(x, "list")
  expect_equal(length(x), 2)
  expect_equal(names(x[[1]]), events)
  expect_equal(names(x[[2]]), stories)
})

test_that("mb_timeline returns as expected", {
  skip_on_cran()
  past <- mb_timeline("past")
  future <- mb_timeline("future")
  x <- mb_timeline("2360s")
  x2 <- mb_timeline(2360)
  for(i in list(past, future, x, x2)){
    expect_is(i, "list")
    expect_equal(length(i), 2)
    expect_equal(names(i[[1]]), events)
    expect_equal(names(i[[2]]), stories)
  }
  expect_identical(x$stories$title[1], x2$stories$title[1])
})
