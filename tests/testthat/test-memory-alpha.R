context("Memory Alpha")

unavail <- "Internet resources currently unavailable."

test_that("memory_alpha returns as expected", {
  skip_on_cran()
  expect_identical(memory_alpha("portals"), .ma_portals)

  grp <- c("id", "url", "group", "subgroup")
  d <- memory_alpha("alternate")
  expect_equal(ncol(d), 4)
  expect_equal(names(d), grp)

  d <- memory_alpha("people")
  expect_equal(ncol(d), 3)
  expect_equal(names(d), grp[1:3])

  d <- memory_alpha("science")
  expect_equal(ncol(d), 3)
  expect_equal(names(d), grp[1:3])

  d <- memory_alpha("series")
  expect_equal(ncol(d), 3)
  expect_equal(names(d), grp[1:3])

  d <- memory_alpha("society")
  expect_equal(ncol(d), 3)
  expect_equal(names(d), grp[1:3])

  d <- memory_alpha("technology")
  expect_equal(ncol(d), 3)
  expect_equal(names(d), grp[1:3])

  d <- memory_alpha("series/Deep Space Nine")
  expect_is(d$metadata[[1]], "NULL")
  expect_equal(dim(d), c(1, 4))
  expect_equal(names(d), c("title", "content", "metadata", "categories"))
  expect_equal(as.character(sapply(d, class)), c("character", rep("list", 3)))
  expect_is(d$content[[1]], "xml_nodeset")

  d <- memory_alpha("people/Klingons")
  expect_equal(ncol(d), 2)
  expect_equal(names(d), c("Klingons", "url"))

  d <- memory_alpha("people/Klingons/Azetbur")
  expect_equal(dim(d), c(1, 4))
  expect_equal(names(d), c("title", "content", "metadata", "categories"))
  expect_equal(as.character(sapply(d, class)), c("character", rep("list", 3)))
  expect_is(d$content[[1]], "xml_nodeset")

  expect_error(memory_alpha("x"), "Invalid endpoint: portal ID.")
  expect_error(memory_alpha("people/Klingons/x"), "Invalid endpoint: x.")
  expect_error(memory_alpha("people/Klingons/Azetbur/x"),
               "Azetbur is an article but `endpoint` does not terminate here.")
})

test_that("ma_article returns as expected", {
  skip_on_cran()
  expect_error(ma_article("x"), "Article not found.")
  closeAllConnections()

  expect_equal(ncol(memory_alpha("people/Acamarians")), 2)
  expect_is(ma_article("Star_Trek")$metadata[[1]], "NULL")

  d0 <- memory_alpha("people/Klingons/Azetbur")
  d <- ma_article("Azetbur")
  expect_equal(unlist(d0), unlist(d))

  d <- ma_article("Azetbur", content_format = "character")
  expect_is(d$content[[1]], "character")
  expect_true(length(d$content[[1]]) > 10)
  expect_true(!any(grepl("\t", d$content[[1]])))
  expect_is(d$metadata[[1]], "tbl_df")
  expect_true(ncol(d$metadata[[1]]) >= 6)
  expect_is(d$categories[[1]], "tbl_df")
  expect_equal(names(d$categories[[1]]), c("categories", "url"))
})

test_that("ma_search returns as expected", {
  skip_on_cran()
  d <- ma_search("Worf")
  expect_equal(ncol(d), 3)
  expect_true(nrow(d) > 20)
  expect_equal(names(d), c("title", "text", "url"))
})

test_that("ma_image and related calls all return as expected", {
  skip_on_cran()
  file <- "File:Ajilon_Prime_Klingon_1.jpg"
  ep <- gsub("File:", "", gsub("_", " ", file))
  x1 <- memory_alpha(paste0("people/Klingons/Memory Alpha images (Klingons)/", ep))
  x2 <- ma_article(file)
  expect_is(x1, "tbl_df")
  expect_identical(x1$categories, x2$categories)
  expect_equal(x1$content, x2$content)
  expect_true(length(x2$content[[1]]) > 10)

  x1 <- ma_image(file)
  expect_is(x1, "ggplot")
})
