#' Get STRING enrichment data.frame for list of genes
#'
#' @param gene character vector of genes to plot on a STRING net
#' @param species STRING taxon identifier, default homo sapiens \code{9606}
#' @param ... other arguments passed to \code{\link[httr:POST]{httr::POST()}}
#' @importFrom httr POST write_disk content
#' @returns enrichment results \code{data frame}
#' @export
get_enr <- function(gene,
                    species = 9606,
                    ...) {

  gene_list <- paste(
    gene,
    collapse = "%0d"
  )

  # instead, could let user put list of all STRING params
  req_body_params <- list(
    identifiers = gene_list,
    species = species
  )

  response <- httr::POST(
    url = pullString:::base_enr_url,
    body = req_body_params,
    ...
  )

  enr_res <- as.data.frame(
    httr::content(response)
  )

  if (nrow(enr_res > 0)) {
    enr_res$category <- gsub(
      pattern = "Function",
      replacement = "GO:Molecular_Function",
      x = enr_res$category
    )
  }

  return(enr_res)
}
