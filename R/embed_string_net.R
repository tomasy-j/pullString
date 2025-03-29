#' Helper function for loading JavaScript code
#' @importFrom shiny tags
#' @export
load_string_js <- function() {
  shiny::tags$script(
    type = "text/javascript",
    src = "https://string-db.org/javascript/combined_embedded_network_v2.0.4.js"
  )
}

#' Embed interactive STRING network
#'
#' This function embeds interactive STRING network in your HTML document
#'
#' @param ids character vector of identifiers, can be protein names, synonyms,
#'   ensembl id, ensemble protein id, HGNC symbol, UniProt or mixed
#' @param species NCBI/STRING taxon, default \code{9606} (human)
#' @param add_color_nodes adds color nodes based on scores to the input proteins
#' @param add_white_nodes adds white nodes based on scores to the input proteins
#'   (added after color nodes)
#' @param required_score threshold of significance to include an interaction, a
#'   number between \code{0 and 1000} (default depends on the network)
#' @param network_flavor the style of edges in the network: evidence (default),
#'   confidence, actions
#' @param network_type network type: \code{functional} (default) or
#'   \code{physical}
#' @param hide_node_labels hides all protein names from the picture (\code{0 or
#'   1}), default is \code{0}
#' @param hide_disconnected_nodes hides all proteins that are not connected to
#'   any other protein in your network (\code{0 or 1}), default is \code{0}
#' @param show_query_node_labels when provided use submitted names as protein
#'   labels in the network image (\code{0 or 1}), default is \code{0}
#' @param block_structure_pics_in_bubbles disables structure pictures inside the
#'   bubble (\code{0 or 1}), default is \code{0}
#' @param caller_identity optional, your identity for \code{STRING DB}
#'   developers. If left blank, defaults to \code{pullString} and current
#'   package version
#' @importFrom shiny tags
#' @importFrom jsonlite toJSON
#' @export
string_request_js <- function(ids,
                          species = 9606,
                          add_color_nodes = 0,
                          add_white_nodes = 0,
                          required_score = 400,
                          network_flavor = "confidence",
                          network_type = "functional",
                          hide_node_labels = 0,
                          hide_disconnected_nodes = 0,
                          show_query_node_labels = 0,
                          block_structure_pics_in_bubbles = 1,
                          caller_identity = usr_agent) {

  shiny::tags$script(paste0(
    '
  function send_request_to_string() {

    getSTRING("https://string-db.org", {
      "species":', species, ',
      "identifiers":', jsonlite::toJSON(ids),',
      "add_color_nodes":', add_color_nodes, ',
      "add_white_nodes":', add_white_nodes, ',
      "required_score":', required_score, ',
      "network_flavor":', jsonlite::toJSON(network_flavor), ',
      "network_type":', jsonlite::toJSON(network_type), ',
      "hide_node_labels":', hide_node_labels, ',
      "hide_disconnected_nodes":', hide_disconnected_nodes, ',
      "show_query_node_labels":', show_query_node_labels, ',
      "block_structure_pics_in_bubbles":', block_structure_pics_in_bubbles, ',
      "caller_identity":', jsonlite::toJSON(usr_agent), ',
    })

  }
  '
  ))
}


#' Perform STRING API request
#' @importFrom shiny tags
#' @export
send_string_request_js <- function() {
  shiny::tags$body(
    onload = "javascript:send_request_to_string()"
  )
}


#' Embed STRING network in your app
#' @importFrom shiny tags
#' @export
embed_string_net <- function() {
  shiny::tags$div(id = "stringEmbedded")
}
