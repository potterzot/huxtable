

test_that("Can use set_cell_properties", {
  htxx <- huxtable(a = 1:5, b = letters[1:5], d = 1:5)
  ht2 <- set_cell_properties(htxx, 1, 1, font = "times", font_size = 24)
  expect_equivalent(font(ht2)[1, 1], "times")
  expect_equivalent(font_size(ht2)[1, 1], 24)
  r <- 2
  c <- 1
  ht3 <- set_cell_properties(htxx, r, c, bold = TRUE, font = "times")
  expect_equivalent(bold(ht3)[2, 1], TRUE)
  expect_equivalent(font(ht3)[2, 1], "times")

})


test_that("set_cell_properties fails with bad arguments", {
  ht <- huxtable(a = 1:5, b = letters[1:5], d = 1:5)
  expect_error(ht <- set_cell_properties(ht, 1, 1, bad = "no!"))
})


test_that("set_* works with variables as arguments", {
  ht_orig <- hux(a = 1:2, b = 1:2)
  rownum <- 2
  colnum <- 1
  ht2 <- set_bold(ht_orig, rownum, colnum, TRUE)
  expect_equivalent(bold(ht2), matrix(c(FALSE, TRUE, FALSE, FALSE), 2, 2))
  boldness <- TRUE
  ht3 <- set_bold(ht_orig, 1:2, 1:2, boldness)
  expect_equivalent(bold(ht3), matrix(TRUE, 2, 2))
})


test_that("set_* works with cell functions", {
  ht <- hux(a = 1:4, b = 1:4)
  ht <- set_font(ht, evens, 1:2, "times")
  ht <- set_font(ht, odds, 1:2, "palatino")
  expect_equivalent(font(ht), matrix(c("palatino", "times"), 4, 2))
  ht <- hux(a = 1:4, b = 1:4)
  ht <- set_font(ht, stripe(1), evens, "times")
  ht <- set_font(ht, stripe(1), odds, "palatino")
  expect_equivalent(font(ht), matrix(c("palatino", "times"), 4, 2, byrow = TRUE))
  ht <- hux(a = 1:4, b = 1:4)
  ht <- set_font(ht, stripe(3, from = 1), stripe(1), "times")
  expect_equivalent(font(ht), matrix(c("times", NA, NA, "times"), 4, 2))
})


test_that("set_* works with row and column functions", {
  ht <- hux(a = 1:4, b = 1:4)
  ht <- set_col_width(ht, evens, "20pt")
  ht <- set_col_width(ht, odds, "40pt")
  ht <- set_row_height(ht, evens, "15pt")
  ht <- set_row_height(ht, odds, "30pt")
  expect_equivalent(col_width(ht), c("40pt", "20pt"))
  expect_equivalent(row_height(ht), rep(c("30pt", "15pt"), 2))
})


test_that("set_*: 2 argument form", {
  ht <- hux(a = c(1, 0), b = c(0, 1))
  ht2 <- set_font(ht, "times")
  expect_equivalent(font(ht2), matrix("times", 2, 2))
  ht3 <- set_font(ht, value = "times")
  expect_equivalent(font(ht3), matrix("times", 2, 2))

  ht4 <- set_col_width(ht, c(.6, .4))
  expect_equivalent(col_width(ht4), c(.6, .4))
  ht5 <- set_row_height(ht, c(.6, .4))
  expect_equivalent(row_height(ht5), c(.6, .4))
})


test_that("set_* works with row and col 'empty'", {
  ht_orig <- hux(a = c(1, 0), b = c(0, 1))
  ht2 <- set_font(ht_orig, 1, everywhere, "times")
  expect_equivalent(font(ht2), matrix(c("times", NA), 2, 2))
  ht3 <- set_font(ht_orig, everywhere, 1, "times")
  expect_equivalent(font(ht3), matrix(c("times", "times", NA, NA), 2, 2))
  ht4 <- set_font(ht_orig, "times")
  expect_equivalent(font(ht4), matrix("times", 2, 2))
})


test_that("set_* default arguments", {
  ht <- hux(a = 1)
  expect_silent(ht1 <- set_bold(ht))
  expect_equivalent(bold(ht1), matrix(TRUE, 1, 1))
  expect_silent(ht2 <- set_bold(ht, 1, 1))
  expect_equivalent(bold(ht1), matrix(TRUE, 1, 1))
  expect_silent(ht3 <- set_italic(ht))
  expect_equivalent(italic(ht3), matrix(TRUE, 1, 1))
})


test_that("set_all_*", {
  ht <- hux(a = c(1, 0), b = c(0, 1))
  ht2 <- set_all_borders(ht, 1)
  expect_equivalent(top_border(ht2), matrix(1, 2, 2))
  ht4 <- set_all_borders(ht, 1, 2, 1)
  expect_equivalent(top_border(ht4), matrix(c(0, 0, 1, 0), 2, 2))
  rownum <- 1
  colnum <- 2
  ht5 <- set_all_borders(ht, rownum, colnum, 1)
  expect_equivalent(top_border(ht5), matrix(c(0, 0, 1, 0), 2, 2))
  border_size <- 2
  ht6 <- set_all_borders(ht, border_size)
  expect_equivalent(top_border(ht6), matrix(border_size, 2, 2))

  ht7 <- set_all_borders(ht, 1:2, tidyselect::matches("a|b"), 1)
  expect_equivalent(top_border(ht7), matrix(1, 2, 2))
})


test_that("set_all_* functions work when huxtable is not attached", {
  # NB as written this test can only be run from the command line; detach call silently fails
  library(huxtable)
  detach(package:huxtable)
  ht <- huxtable::hux(a = c(1, 0), b = c(0, 1))
  expect_silent(ht2 <- huxtable::set_all_borders(ht, 1))
  expect_silent(ht3 <- huxtable::set_all_border_colors(ht, "red"))
  expect_silent(ht4 <- huxtable::set_all_padding(ht, 1))
  expect_silent(ht5 <- huxtable::set_all_border_styles(ht, "double"))
  library(huxtable) # we reattach before these tests, or we have problems with unavailable methods
  expect_equivalent(top_border(ht2), matrix(1, 2, 2))
  expect_equivalent(top_border_color(ht3), matrix("red", 2, 2))
  expect_equivalent(top_padding(ht4), matrix(1, 2, 2))
  expect_equivalent(top_border_style(ht5), matrix("double", 2, 2))
})


test_that("set_outer_*", {
  ht <- hux(a = 1:3, b = 1:3, c = 1:3)

  check_borders <- function (ht, suffix, un, set) {
    funcs <- paste0(c("top", "bottom", "left", "right"), sprintf("_border%s", suffix))
    funcs <- mget(funcs, inherits = TRUE)
    expect_equivalent(funcs[[1]](ht), matrix(c(un, un, un, un, set, un, un, set, un), 3, 3))
    expect_equivalent(funcs[[2]](ht), matrix(c(un, un, un, un, un, set, un, un, set), 3, 3))
    expect_equivalent(funcs[[3]](ht), matrix(c(un, un, un, un, set, set, un, un, un), 3, 3))
    expect_equivalent(funcs[[4]](ht), matrix(c(un, un, un, un, un, un, un, set, set), 3, 3))
  }

  ht2 <- set_outer_borders(ht, 2:3, 2:3, 1)
  check_borders(ht2, "", 0, 1)
  ht3 <- set_outer_borders(ht, c(F, T, T), c(F, T, T), 1)
  check_borders(ht3, "", 0, 1)
  ht4 <- set_outer_borders(ht, 2:3, c("b", "c"), 1)
  check_borders(ht4, "", 0, 1)
  # NB: testthat has a `matches` function
  ht5 <- set_outer_borders(ht, 2:3, tidyselect::matches("b|c"), 1)
  check_borders(ht5, "", 0, 1)

  ht2 <- set_outer_border_colors(ht, 2:3, 2:3, "red")
  check_borders(ht2, "_color", NA, "red")
  ht3 <- set_outer_border_colors(ht, c(F, T, T), c(F, T, T), "red")
  check_borders(ht3, "_color", NA, "red")
  ht4 <- set_outer_border_colors(ht, 2:3, c("b", "c"), "red")
  check_borders(ht4, "_color", NA, "red")
  # NB: testthat has a `matches` function
  ht5 <- set_outer_border_colors(ht, 2:3, tidyselect::matches("b|c"), "red")
  check_borders(ht5, "_color", NA, "red")

  ht2 <- set_outer_border_styles(ht, 2:3, 2:3, "double")
  check_borders(ht2, "_style", "solid", "double")
  ht3 <- set_outer_border_styles(ht, c(F, T, T), c(F, T, T), "double")
  check_borders(ht3, "_style", "solid", "double")
  ht4 <- set_outer_border_styles(ht, 2:3, c("b", "c"), "double")
  check_borders(ht4, "_style", "solid", "double")
  # NB: testthat has a `matches` function
  ht5 <- set_outer_border_styles(ht, 2:3, tidyselect::matches("b|c"), "double")
  check_borders(ht5, "_style", "solid", "double")
})


test_that("set_outer_borders() works with non-standard/empty position arguments", {
  ht <- hux(a = 1:2, b = 1:2)

  ht2 <- set_outer_borders(ht, 1)
  ht3 <- set_outer_borders(ht, everywhere, everywhere, 1)
  for (h in list(ht2, ht3)) {
    expect_equivalent(top_border(h), matrix(c(1, 0, 1, 0), 2, 2))
    expect_equivalent(bottom_border(h), matrix(c(0, 1, 0, 1), 2, 2))
    expect_equivalent(left_border(h), matrix(c(1, 1, 0, 0), 2, 2))
    expect_equivalent(right_border(h), matrix(c(0, 0, 1, 1), 2, 2))
  }

  ht4 <- set_outer_borders(ht, evens, everywhere, 1)
  expect_equivalent(top_border(ht4), matrix(c(0, 1, 0, 1), 2, 2))
  expect_equivalent(bottom_border(ht4), matrix(c(0, 1, 0, 1), 2, 2))
  expect_equivalent(left_border(ht4), matrix(c(0, 1, 0, 0), 2, 2))
  expect_equivalent(right_border(ht4), matrix(c(0, 0, 0, 1), 2, 2))

})


test_that("set_contents works", {
  ht <- hux(1:3, 1:3)

  expect_equivalent(set_contents(ht, 1:6), hux(1:3, 4:6))
  expect_equivalent(set_contents(ht, 1, 1, 0), hux(c(0, 2:3), 1:3))
  expect_equivalent(set_contents(ht, 1, 1, 0), hux(c(0, 2:3), 1:3))
  expect_equivalent(set_contents(ht, 2:3, 2, 3:2), hux(1:3, c(1, 3, 2)))

  ht <- hux(a = 1:3, b = 1:3)
  align(ht) <- "right"
  test_props_same <- function(ht2) expect_equivalent(align(ht2), align(ht))
  test_props_same(set_contents(ht, 1:6))
  test_props_same(set_contents(ht, 1, 1, 0))
  test_props_same(set_contents(ht, 1, 1, 0))
  test_props_same(set_contents(ht, 2:3, 2, 3:2))

  expect_equivalent(set_contents(ht, 1, "a", 0), set_contents(ht, 1, 1, 0))
  # dplyr::matches not testthat::matches
  skip_if_not_installed("dplyr")
  expect_equivalent(set_contents(ht, 1, dplyr::matches("b"), 0), set_contents(ht, 1, 2, 0))
})

test_that("merge_cells", {
  ht <- hux(a = 1:3, b = 1:3)
  expect_silent(ht2 <- merge_cells(ht, 1, 1:2))
  expect_silent(ht2 <- merge_cells(ht2, 2:3, 1))
  expect_equivalent(colspan(ht2), matrix(c(2, 1, 1, 1, 1, 1), 3, 2))
  expect_equivalent(rowspan(ht2), matrix(c(1, 2, 1, 1, 1, 1), 3, 2))

  expect_silent(ht3 <- merge_cells(ht, 1, everywhere))
  expect_equivalent(colspan(ht3), matrix(c(2, 1, 1, 1, 1, 1), 3, 2))

  expect_silent(ht4 <- merge_cells(ht, 1:2, 1:2))
  expect_equivalent(colspan(ht4), matrix(c(2, 1, 1, 1, 1, 1), 3, 2))
  expect_equivalent(rowspan(ht4), matrix(c(2, 1, 1, 1, 1, 1), 3, 2))

  expect_silent(ht5 <- merge_cells(ht, c(1, 3), 1))
  expect_equivalent(rowspan(ht5), matrix(c(3, 1, 1, 1, 1, 1), 3, 2))

})


test_that("merge_across/down", {
  ht <- hux(1:2, 1:2)
  expect_silent(ht2 <- merge_across(ht, 1:2, 1:2))
  expect_equivalent(colspan(ht2), matrix(c(2, 2, 1, 1), 2, 2))

  expect_silent(ht2 <- merge_down(ht, 1:2, 1:2))
  expect_equivalent(rowspan(ht2), matrix(c(2, 1, 2, 1), 2, 2))
})


test_that("merge_repeated_rows", {
  ht <- hux(a = c(1, 2, 2), b = c("x", "x", "y"), c = 1:3)

  ht2 <- merge_repeated_rows(ht)
  expect_equivalent(rowspan(ht2), matrix(c(1, 2, 1, 2, 1, 1, 1, 1, 1), 3, 3))

  ht3 <- merge_repeated_rows(ht, everywhere, "a")
  expect_equivalent(rowspan(ht3), matrix(c(1, 2, 1, 1, 1, 1, 1, 1, 1), 3, 3))

  ht4 <- merge_repeated_rows(ht, everywhere, 1)
  expect_equivalent(rowspan(ht4), matrix(c(1, 2, 1, 1, 1, 1, 1, 1, 1), 3, 3))

  ht5 <- merge_repeated_rows(ht, ht$a > 1, "b")
  expect_equivalent(rowspan(ht5), matrix(1, 3, 3))

  ht6 <- merge_repeated_rows(ht, ht$a > 1, "a")
  expect_equivalent(rowspan(ht6), matrix(c(1, 2, 1, 1, 1, 1, 1, 1, 1), 3, 3))

  ht7 <- merge_repeated_rows(ht, final(2), "b")
  expect_equivalent(rowspan(ht7), matrix(1, 3, 3))

  ht8 <- merge_repeated_rows(ht, final(2), "a")
  expect_equivalent(rowspan(ht8), matrix(c(1, 2, 1, 1, 1, 1, 1, 1, 1), 3, 3))

  expect_warning(merge_repeated_rows(ht, ht$c %in% c(1, 3), "a"))
  expect_warning(merge_repeated_rows(ht, c(1, 3), "a"))

  ht9 <- ht
  ht9$b <- as.factor(ht9$b)
  ht9 <- merge_repeated_rows(ht9)
  expect_equivalent(rowspan(ht9), matrix(c(1, 2, 1, 2, 1, 1, 1, 1, 1), 3, 3))

  ht_long <- hux(a = c(1, 2, 2, 1, 1))
  ht_long<- merge_repeated_rows(ht_long)
  expect_equivalent(rowspan(ht_long), matrix(c(1, 2, 1, 2, 1), 5, 1))
})

