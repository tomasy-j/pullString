#' Helper function for loading JavaScript code
#' @importFrom shiny tags
#' @export
load_string_js <- function() {
  shiny::tags$script(
    type = "text/javascript",
    src = "https://string-db.org/javascript/combined_embedded_network_v2.0.4.js"
  )
}

#' Define STRING network parameters
#'
#' @param ids s
#' @param species s
#' @param add_color_nodes s
#' @param add_white_nodes h
#' @param required_score h
#' @param required_score h
#' @param network_flavor g
#' @param network_type g
#' @param hide_node_labels f
#' @param hide_disconnected_nodes d
#' @param show_query_node_labels d
#' @param block_structure_pics_in_bubbles d
#' @param caller_identity d
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
