# including the main.R file to be tested
source("../main.R", chdir = TRUE)

# loading the "testthat" library for Unit Testing
library(testthat)

# testing the proper query
test_that("correct query", {
  expect_equal(keywordAssoc("game"), 
               list("league", "league of legends", "lol", "logo", "game", "video game", "computer game"))
})

# testing a query with no results
test_that("query with no result", {
  expect_equal(keywordAssoc("blahbluebleh!"),
               NULL)
})

# testing an empty query.
test_that("empty query", {
  expect_equal(keywordAssoc(""), 
               NULL)
})

# please note with running the following script in the command line, we can see a report on tests pass/failure
# testthat::test_dir("tests")
