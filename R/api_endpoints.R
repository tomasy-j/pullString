# This file stores all STRING DB API endpoints used in the package


pkg_description <- utils::packageDescription("pullString")

#' Set user agent - package name and version
#' @examples
#' pullString:::usr_agent
usr_agent <- paste(pkg_description$Package, pkg_description$Version)


#' STRING API URL
#'
#' Base STRING DB API URL for constructing requests
#' @return \code{https://version-12-0.string-db.org/api}
#' @examples
#' pullString:::base_string_url
base_string_url <- "https://version-12-0.string-db.org/api"


#' STRING endpoint for current stable version
endpoint_version <- "tsv/version"

#' STRING endpoint for mapping identifiers
endpoint_ids <- "tsv/get_string_ids"

#' STRING endpoint for network interactions
endpoint_net_interactions <- "tsv/network"

#' STRING endpoint for interaction partners
endpoint_interact_partners <- "tsv/interaction_partners"

#' STRING endpoint for enrichment table
endpoint_enrichment_tab <- "tsv/enrichment"

#' STRING endpoint for generating STRING URL
endpoint_get_link <- "tsv/get_link"

#' STRING endpoint for protein similarity scores (homology)
endpoint_get_homology_scores <- "tsv/homology"

#' STRING endpoint for best protein homology
endpoint_get_best_homology <- "tsv/homology_best"

#' STRING endpoint for functional annotation
endpoint_get_functional_annotation <- "tsv/functional_annotation"

#' STRING endpoint for interaction enrichment
endpoint_get_interaction_enrichment <- "tsv/ppi_enrichment"

#' STRING endpoint for values/ranks enrichment
# endpoint_get_values_ranks_enrichment <- "tsv/valuesranks_enrichment_submit"
# needs api key

#' STRING endpoint for enrichment plot
endpoint_get_enrichment_plot <- "image/enrichmentfigure"

#' STRING endpoint for \code{.png} network
endpoint_get_png_network <- "image/network"

#' STRING endpoint for high resolution \code{.png} network
endpoint_get_highres_png_network <- "highres_image/network"
