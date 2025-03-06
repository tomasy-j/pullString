#' Get STRING .png for list of genes
#'
#' @param gene character vector of genes to plot on a STRING net
#' @param species STRING taxon identifier, default homo sapiens \code{9606}
#' @param png_filename path to write png
#' @param label_font_size font size on save png, default \code{16}
#' @param ... other arguments passed to \code{\link[httr:POST]{httr::POST()}}
#' @importFrom httr POST write_disk
#' @returns saved .png to \code{png_filename}
#' @export
get_string_png <- function(gene,
                           species = 9606,
                           png_filename,
                           label_font_size = 16,
                           ...) {

  gene_list <- paste(
    gene,
    collapse = "%0d"
  )

  # instead, could let user put list of all STRING params
  req_body_params <- list(
    identifiers = gene_list,
    species = species,
    network_flavor = "confidence",
    custom_label_font_size = label_font_size
  )

  httr::POST(
    url = pullString:::base_img_url,
    body = req_body_params,
    httr::write_disk(png_filename, overwrite = TRUE),
    ...
  )
}
