#' Get the current STRING version and its stable address
#'
#' @importFrom httr2 request req_url_path_append req_user_agent req_perform
#'   resp_body_string
#' @importFrom readr read_delim
#' @returns \code{tibble} with STRING version and current stable website URL
#'   address
#' @examples
#' get_string_version()
#' @export
get_string_version <- function() {

  response <- httr2::request(pullString:::base_string_url) |>
    httr2::req_url_path_append(pullString:::endpoint_version) |>
    httr2::req_user_agent(pullString:::usr_agent) |>
    httr2::req_perform() |>
    httr2::resp_body_string()

  response <- readr::read_delim(
    file = response,
    show_col_types = FALSE
  )

  return(response)
}


#' Maps common protein names, synonyms and UniProt identifiers into STRING
#' identifiers
#'
#' @param ids character vector of identifiers, can be protein names, synonyms,
#'   ensembl id, ensemble protein id, HGNC symbol, UniProt or mixed
#' @param species NCBI/STRING taxon, default \code{9606} (human)
#' @param ... other params passed to API
#' @importFrom httr2 request req_url_path_append  req_url_query req_user_agent
#'   req_perform resp_body_string
#' @importFrom readr read_delim
#' @returns \code{tibble} with STRING preferred name, annotation and taxon
#'   details
#' @examples
#' get_string_identifiers(
#'   c("ENSG00000133110", # POSTN
#'     "ENSP00000401645", # SERPINB2
#'     "CXCL10"
#'   )
#' )
#' @export
get_string_identifiers <- function(ids, species = 9606, ...) {

  ids_url <- paste(
    ids,
    collapse = "%0d"
  )

  req_body_params <- list(
    ...,
    identifiers = ids_url,
    species = species
  )

  response <- httr2::request(pullString:::base_string_url) |>
    httr2::req_url_path_append(pullString:::endpoint_ids) |>
    httr2::req_url_query(!!!req_body_params) |>
    httr2::req_user_agent(pullString:::usr_agent) |>
    httr2::req_perform() |>
    httr2::resp_body_string()

  response <- readr::read_delim(
    file = response,
    show_col_types = FALSE
  )

  return(response)
}
