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
    "get_interact_partners returns 4 x 13 table when asking for top
     interaction for each of 4 input genes", {
       expect_equal(dim(interaction_partn_response), c(4, 13))
     }
  )

  test_that("get_interact_partners column names match", {
    expect_equal(
      names(interaction_partn_response),
      c("stringId_A", "stringId_B", "preferredName_A", "preferredName_B",
        "ncbiTaxonId", "score", "nscore", "fscore", "pscore", "ascore",
        "escore", "dscore", "tscore")
    )
  })

})



with_mock_dir("get_homology", {
  get_homology_response <- get_homology(
    ids = input_genes,
    species = 9606
  )

  test_that(
    "get_homology returns 4 x 5 table for given input genes", {
       expect_equal(dim(get_homology_response), c(4, 5))
     }
  )

  test_that("get_homology column names match", {
    expect_equal(
      names(get_homology_response),
      c("ncbiTaxonId_A", "stringId_A", "ncbiTaxonId_B", "stringId_B",
        "bitscore")
    )
  })

})


with_mock_dir("get_best_homology", {
  get_best_homology_response <- get_best_homology(
    ids = input_genes,
    species = 9606,
    species_b = 10090
  )

  test_that(
    "species parameter equals to ncbiTaxonId_A", {
      expect_true(
        all(get_best_homology_response$ncbiTaxonId_A == 9606)
      )
    }
  )

  test_that(
    "species_b parameter equals to ncbiTaxonId_B", {
      expect_true(
        all(get_best_homology_response$ncbiTaxonId_B == 10090)
      )
    }
  )

  test_that(
    "get_best_homology returns 4 x 5 table for given input genes", {
       expect_equal(dim(get_best_homology_response), c(4, 5))
     }
  )

  test_that("get_best_homology column names match", {
    expect_equal(
      names(get_best_homology_response),
      c("ncbiTaxonId_A", "stringId_A", "ncbiTaxonId_B", "stringId_B",
        "bitscore")
    )
  })

})


with_mock_dir("get_enrichment", {
  get_enrichment_response <- get_enrichment(
    ids = input_genes
  )

  test_that("get_enrichment column names match", {
    expect_equal(
      names(get_enrichment_response),
      c("category", "term", "number_of_genes", "number_of_genes_in_background",
        "ncbiTaxonId", "inputGenes", "preferredNames", "p_value", "fdr",
        "description")
    )
  })

})


with_mock_dir("get_functional_annotation", {
  get_functional_annotation_response <- get_functional_annotation(
    ids = input_genes
  )

  test_that("get_functional_annotation column names match", {
    expect_equal(
      names(get_functional_annotation_response),
      c("category", "term", "number_of_genes", "ratio_in_set", "ncbiTaxonId",
        "inputGenes", "preferredNames", "description")
    )
  })

})


with_mock_dir("get_ppi_enrichment", {
  get_ppi_enrichment_response <- get_ppi_enrichment(
    ids = input_genes
  )

  test_that("get_ppi_enrichment column names match", {
    expect_equal(
      names(get_ppi_enrichment_response),
      c("number_of_nodes", "number_of_edges", "average_node_degree",
        "local_clustering_coefficient", "expected_number_of_edges", "p_value")
    )
  })

})


test_that("get_link gives correct url", {

  ref_url <- "https://version-12-0.string-db.org/cgi/link?to=607C938394238655"
  expect_equal(
    get_link(ids = input_genes),
    ref_url
  )

})
