context("Memory Beta")

unavail <- "Internet resources currently unavailable."

test_that("memory_beta returns as expected", {
  skip_on_cran()
  expect_identical(memory_beta("portals"), .mb_portals)

  for(id in .mb_portals$id){
    d <- memory_beta(id)
    expect_equal(ncol(d), 2)
    expect_equal(names(d), c(id, "url"))
  }

  d <- memory_beta("books/TOS novels/All That's Left")
  expect_equal(dim(d), c(1, 4))
  expect_equal(names(d), c("title", "content", "metadata", "categories"))
  expect_equal(as.character(sapply(d, class)), c("character", rep("list", 3)))
  expect_is(d$content[[1]], "xml_nodeset")

  ep <- "characters/Characters by races and cultures/Klingonoids/Klingons/Azetbur, daughter of Gorkon"
  d <- memory_beta(ep)
  expect_equal(dim(d), c(1, 4))
  expect_equal(names(d), c("title", "content", "metadata", "categories"))
  expect_equal(as.character(sapply(d, class)), c("character", rep("list", 3)))
  expect_is(d$content[[1]], "xml_nodeset")

  expect_error(memory_beta("x"), "Invalid endpoint: portal ID.")
  expect_error(memory_beta("characters/x"), "Invalid endpoint: x.")
  expect_error(memory_beta(file.path(ep, "x")),
               "Azetbur, daughter of Gorkon is an article but `endpoint` does not terminate here.")
})

test_that("mb_article returns as expected", {
  skip_on_cran()
  expect_error(mb_article("x"), "Article not found.")
  closeAllConnections()

  expect_equal(ncol(memory_beta("books")), 2)
  expect_is(mb_article("Star_Trek")$metadata[[1]], "NULL")

  d0 <- memory_beta("books/Hardcover")
  d <- mb_article("Hardcover")
  expect_equal(unlist(d0), unlist(d))

  d <- mb_article("Azetbur,_daughter_of_Gorkon", content_format = "character")
  expect_is(d$content[[1]], "character")
  expect_true(length(d$content[[1]]) > 10)
  expect_true(!any(grepl("\t", d$content[[1]])))
  expect_is(d$metadata[[1]], "tbl_df")
  expect_true(ncol(d$metadata[[1]]) >= 6)
  expect_is(d$categories[[1]], "tbl_df")
  expect_equal(names(d$categories[[1]]), c("categories", "url"))
})

test_that("mb_search returns as expected", {
  skip_on_cran()
  d <- mb_search("Worf")
  expect_equal(ncol(d), 3)
  expect_true(nrow(d) > 20)
  expect_equal(names(d), c("title", "text", "url"))
})

test_that("mb_image and related calls all return as expected", {
  skip_on_cran()
  file <- "File:DataBlaze.jpg"
  ep <- file.path("characters",
                  "Memory Beta images (characters)",
                  "Memory Beta images (regular and recurring characters)",
                  "Memory Beta images (TNG regular and recurring characters)",
                  "Memory Beta images (Data)", gsub("File:", "", file))
  x1 <- memory_beta(ep)
  x2 <- mb_article(file)
  expect_is(x1, "tbl_df")
  expect_identical(x1$categories, x2$categories)
  expect_is(x1$categories[[1]], "tbl_df")
  expect_equal(x1$content, x2$content)
  expect_true(length(x2$content[[1]]) > 10)

  x1 <- mb_image(file)
  expect_is(x1, "ggplot")
})
