with_mock_dir("get_string_version", {
  string_version_response <- get_string_version()

  test_that("get_string_version outputs a table with 1 row", {
    expect_equal(nrow(string_version_response), 1)
  })

  test_that("get_string_version column names match", {
    expect_equal(
      names(string_version_response),
      c("string_version", "stable_address")
      )
  })

  test_that("get_string_version check version", {
    expect_equal(
      string_version_response$string_version,
      12
    )
  })

  test_that("get_string_version check stable address", {
    expect_equal(
      string_version_response$stable_address,
      "https://version-12-0.string-db.org"
    )
  })
})
