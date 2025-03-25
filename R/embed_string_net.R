
load_string_js <- function() {
  shiny::tags$script(
    type = "text/javascript",
    src = "https://string-db.org/javascript/combined_embedded_network_v2.0.4.js"
  )
}

# add other params
string_req_js <- function(genes) {
  shiny::tags$script(paste0(
  '
  function send_request_to_string() {

  getSTRING("https://string-db.org", {
  "species": "9606",
  "identifiers": ["POSTN"],
  "add_color_nodes": 3,
  "add_white_nodes": 5,
  "required_score": 990,
  "network_flavor": "confidence",
  "network_type": "functional",
  "hide_node_labels": 0,
  "hide_disconnected_nodes": 0,
  "show_query_node_labels": 0,
  "block_structure_pics_in_bubbles": 0,
  "caller_identity": "www.awesome_app.org"
  })

  }
  '
  ))
}

send_string_req_js <- function() {
  shiny::tags$body(
    onload = "javascript:send_request_to_string()"
  )
}

embed_string_net <- function() {
  shiny::tags$div(id = "stringEmbedded")
}

