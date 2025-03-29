#'Function for creating other functions that call STRING API endpoints
#'
#'This is a higher-order function that is not a part of user interface. It is
#'internally used to create other functions that call STRING API endpoints and
#'collect \code{image} response
#'
#'@param endpoint STRING API endpoint
#'@importFrom httr2 request req_url_path_append req_method req_body_form
#'  req_user_agent req_perform resp_body_raw
#'@importFrom readr write_file
.create_api_png_resp <- function(endpoint) {

  api_req <- function(ids, species = 9606, png_filename, ...) {

    ids_req <- paste(
      ids,
      collapse = "%0d"
    )

    response <- httr2::request(base_url = base_string_url) |>
      httr2::req_url_path_append(endpoint) |>
      httr2::req_method("POST") |>
      httr2::req_body_form(
        identifiers = ids_req,
        species = species,
        ...
      ) |>
      httr2::req_user_agent(usr_agent) |>
      httr2::req_perform() |>
      httr2::resp_body_raw()

    readr::write_file(
      x = response,
      file = png_filename
    )

  }

  return(api_req)
}


#' Retrieve \code{png} network
#'
#' Retrieve an image of a STRING network of a neighborhood surrounding one or
#' more proteins or ask STRING to show only the network of interactions between
#' your input proteins. Both the network flavors (confidence and evidence) and
#' network types (functional and physical) are accessible through the API.
#'
#' @param ids character vector of identifiers, can be protein names, synonyms,
#'   ensembl id, ensemble protein id, HGNC symbol, UniProt or mixed
#' @param species NCBI/STRING taxon, default \code{9606} (human)
#' @param png_filename path to save \code{png} file with network
#' @param ... other params passed to \code{STRING API} request, options:
#'
#' @section Other arguments:
#' \itemize{
#'   \item \code{add_color_nodes} - adds color nodes based on scores to the
#'   \item \code{add_white_nodes} - adds white nodes based on scores to the
#'   input proteins
#'   \item \code{required_score} - threshold of significance to include an
#'   interaction, a number between 0 and 1000 (default depends on the network)
#'   number between 0 and 1000 (default depends on the network)
#'   \item \code{network_type} - network type: \code{functional} (default),
#'   \code{physical}
#'   \item \code{network_flavor} - the style of edges in the network:
#'   \code{evidence} (default), \code{confidence, actions}
#'   \item \code{hide_node_labels} - hides all protein names from the picture
#'   \code{(0 or 1)} default is \code{0}
#'   \item \code{hide_disconnected_nodes} - hides all
#'   proteins that are not connected to any other protein in your network
#'   \code{(0 or 1)}, default is \code{0} labels in the network image \code{(0
#'   or 1)}, default is \code{0}
#'   \item \code{block_structure_pics_in_bubbles} - disables structure pictures
#'   inside the bubble \code{(0 or 1)} (default is \code{0})
#'   \item \code{flat_node_design} - disable 3D bubble design \code{(0
#'   or 1)}, default is \code{0}
#'   \item \code{center_node_labels} - center
#'   protein names on nodes \code{(0 or 1)}, default is \code{0}
#'   \item
#'   \code{custom_label_font_size} - change font size of the protein names
#'   \code{(from 5 to 50)}, default is \code{12}
#'   \item \code{caller_identity} -
#'   optional, your identity for \code{STRING DB} developers. If left blank,
#'   defaults to \code{pullString} and current package version
#' }
#'
#' @section Details: If you query the API with one protein the
#'   \code{add_white_nodes} parameter is automatically set to \code{10}, so you
#'   can see the interaction neighborhood of your query protein. However,
#'   similarly to the STRING webpage, whenever you query the API with more than
#'   one protein we show only the interactions between your input proteins. You
#'   can, of course, always extend the interaction neighborhood by setting
#'   \code{add_color} or \code{white_nodes} parameter to the desired value.
#' @examples
#' \dontrun{
#' get_png_network(
#'   ids = c("POSTN", "IFNA1", "SERPINB2", "CXCL10"),
#'   png_filename = "./string_net.png"
#' )
#' }
#' @export
get_png_network <- .create_api_png_resp(endpoint_get_png_network)


#' Retrieve higher resolution \code{png} network
#' @inherit get_png_network
get_highres_png_network <- .create_api_png_resp(endpoint_get_highres_png_network)


#' Get enrichment plot
#'
#' This function enables the visualization of enrichment analysis, providing a
#' way to explore results across three key dimensions:
#' \itemize{
#' \item Enrichment signal (\code{x-axis})
#' \item False Discovery Rate (\code{FDR}) represented by the dot color
#' \item Protein count in the network indicated by the dot size
#' }
#'
#' @inheritParams get_png_network
#' @section Other arguments:
#' \itemize{
#'   \item \code{category} -term category (e.g., KEGG, WikiPathways, etc. See
#'   the table below for all category keys. Default is \code{Process})
#'   \item \code{group_by_similarity} - threshold for visually grouping related
#'   terms on the plot, ranging from \code{0.1 to 1}, in steps of \code{0.1}
#'   (e.g. \code{0.8)}, with no grouping applied by default
#'   \item \code{color_palette} - color palette to represent FDR values
#'   (\code{mint_blue, lime_emerald, green_blue, peach_purple, straw_navy,
#'   yellow_pink}, default is \code{mint_blue})
#'   \item \code{number_of_term_shown} - maximum number of terms displayed on
#'   the plot (default is \code{10})
#'   \item \code{x_axis} - specifies the order of the terms and the variable on
#'   the x-axis (\code{signal, strength, FDR, gene_count}, default is
#'   \code{signal})
#' }
#'
#' @section Details:
#' Category keys:
#' \itemize{
#'   \item \code{Process} - Biological Process (Gene Ontology)
#'   \item \code{Function} - 	Molecular Function (Gene Ontology)
#'   \item \code{Component} - Cellular Component (Gene Ontology)
#'   \item \code{Keyword} - Annotated Keywords (UniProt)
#'   \item \code{KEGG} - KEGG Pathways
#'   \item \code{RCTM} - Reactome Pathways
#'   \item \code{HPO} - Human Phenotype (Monarch)
#'   \item \code{MPO} - he Mammalian Phenotype Ontology (Monarch)
#'   \item \code{DPO} - Drosophila Phenotype (Monarch)
#'   \item \code{WPO} - C. elegans Phenotype Ontology (Monarch)
#'   \item \code{ZPO} - Zebrafish Phenotype Ontology (Monarch)
#'   \item \code{FYPO} - Fission Yeast Phenotype Ontology (Monarch)
#'   \item \code{Pfam} - Protein Domains (Pfam)
#'   \item \code{SMART} - Protein Domains (SMART)
#'   \item \code{InterPro} - Protein Domains and Features (InterPro)
#'   \item \code{PMID} - Reference Publications (PubMed)
#'   \item \code{NetworkNeighborAL} - Local Network Cluster (STRING)
#'   \item \code{COMPARTMENTS} - Subcellular Localization (COMPARTMENTS)
#'   \item \code{TISSUES} - Tissue Expression (TISSUES)
#'   \item \code{DISEASES} - Disease-gene Associations (DISEASES)
#'   \item \code{WikiPathways} - WikiPathways
#' }
#' @examples
#' \dontrun{
#' get_enrichment_plot(
#'   ids = c("POSTN", "IFNA1", "SERPINB2"),
#'   png_filename = "string_enrichment_fig.png"
#' )
#' }
#' @export
get_enrichment_plot <- .create_api_png_resp(endpoint_get_enrichment_plot)
