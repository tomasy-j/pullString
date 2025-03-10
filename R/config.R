# This file stores all STRING DB API endpoints used in the package


pkg_description <- utils::packageDescription("pullString")

#' Set user agent - package name and version
#' @examples
#' pullString:::usr_agent
usr_agent <- paste(pkg_description$Package, pkg_description$Version)


#' STRING API URL
#'
#' Base STRING DB API URL for constructing requests
#' @return \code{https://string-db.org/api}
#' @examples
#' pullString:::base_string_url
base_string_url <- "https://version-12-0.string-db.org/api"



#' STRING endpoint for current stable version
endpoint_version <- "tsv/version"

#' STRING endpoint for mapping identifiers
endpoint_ids <- "tsv/get_string_ids"

#' STRING endpoint for \code{.png} network
endpoint_png_network <- "image/network"

#' STRING endpoint for enrichment \code{tsv} table
endpoint_enrichment_tab <- "tsv/enrichment"






