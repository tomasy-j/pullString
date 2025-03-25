test_that(".create_api_tsv_resp returns a function", {
  api_function_creator <- .create_api_tsv_resp(endpoint = endpoint_ids)

  expect_equal(
    class(api_function_creator),
    "function"
  )
})


input_genes <- c("POSTN", "SERPINB2", "CXCL10", "IFNA1")

with_mock_dir("get_string_identifiers", {
  string_ids_response <- get_string_identifiers(
    ids = input_genes,
    species = 9606,
    echo_query = 1,
    limit = 1
  )

  test_that(
    "get_string_identifiers outputs a 4 x 7 table when using 4 input genes and
    limit to one best match", {
      expect_equal(dim(string_ids_response), c(4, 7))
    }
  )

  test_that("get_string_identifiers column names match", {
    expect_equal(
      names(string_ids_response),
      c("queryItem", "queryIndex", "stringId", "ncbiTaxonId", "taxonName",
        "preferredName", "annotation")
    )
  })

})


with_mock_dir("get_interact_partners", {
  interaction_partn_response <- get_interact_partners(
    ids = input_genes,
    species = 9606,
    limit = 1
  )

  test_that(
    "interaction_partn_response returns 4 x 13 table when asking for top
     interaction for each of 4 input genes", {
       expect_equal(dim(interaction_partn_response), c(4, 13))
     }
  )

  test_that("get_string_identifiers column names match", {
    expect_equal(
      names(interaction_partn_response),
      c("stringId_A", "stringId_B", "preferredName_A", "preferredName_B",
        "ncbiTaxonId", "score", "nscore", "fscore", "pscore", "ascore",
        "escore", "dscore", "tscore")
    )
  })

})
