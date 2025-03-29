#' Function for creating other functions that call STRING API endpoints
#'
#' This is a higher-order function that is not a part of the user interface. It
#' is internally used to create other functions that call STRING API endpoints
#' and collect \code{tsv} response
#'
#' @param endpoint STRING API endpoint
#' @importFrom httr2 request req_url_path_append req_method req_body_form
#'   req_user_agent req_perform resp_body_string
#' @importFrom readr read_delim
#' @returns \code{function} to perform STRING API request
.create_api_tsv_resp <- function(endpoint) {

  api_req <- function(ids, species = 9606, ...) {

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
      httr2::resp_body_string()

    response <- readr::read_delim(
      file = response,
      show_col_types = FALSE
    )

    return(response)
  }

  return(api_req)
}


#' Maps common protein names, synonyms and UniProt identifiers into STRING
#' identifiers
#'
#' @param ids character vector of identifiers, can be protein names, synonyms,
#'   ensembl id, ensemble protein id, HGNC symbol, UniProt or mixed
#' @param species NCBI/STRING taxon, default \code{9606} (human)
#' @param ... other params passed to \code{STRING API} request, options:
#' @section Other arguments:
#' \itemize{
#'   \item \code{echo_query} - insert column with your input identifier, takes
#'   values \code{0} or \code{1}, default is \code{0}
#'   \item \code{limit} - limits the number of matches per query identifier
#'   (best matches come first)
#'   \item \code{caller_identity} - optional, your identity for \code{STRING DB}
#'   developers. If left blank, defaults to \code{pullString} and current
#'   package version
#' }
#' @section Value: \code{tibble} with STRING preferred name, annotation and
#'   taxon details
#' @examples
#' \dontrun{
#' get_string_identifiers(
#'   c("ENSG00000133110", # POSTN
#'     "ENSP00000401645", # SERPINB2
#'     "CXCL10"
#'   )
#' )
#' }
#' @export
get_string_identifiers <- .create_api_tsv_resp(endpoint_ids)


#'Retrieves the network interactions for your input protein(s)
#'
#'The network API function also allows you to retrieve your STRING interaction
#'network for one or multiple proteins. It will tell you the combined score and
#'all the channel specific scores for the set of proteins. You can also extend
#'the network neighborhood by setting \code{add_nodes}, which will add, to your
#'network, new interaction partners in order of their confidence.
#'
#'@inheritParams get_string_identifiers
#'@param ... other params passed to \code{STRING API} request, options:
#'
#'@section Other arguments:
#' \itemize{
#'   \item \code{required_score} - threshold of significance to include an
#'   interaction, a number between 0 and 1000 (default depends on the network)
#'   \item \code{network_type} - options: \code{functional} (default), or
#'   \code{physical} come first)
#'   \item \code{add_nodes} - a number of proteins with to the network based on
#'   their confidence score
#'   \item \code{show_query_node_labels} - when
#'   available use submitted names in the preferredName column. Takes values
#'   \code{0} or \code{1}, default is \code{0}
#'   \item \code{caller_identity} -
#'   optional, your identity for \code{STRING DB} developers. If left blank,
#'   defaults to \code{pullString} and current package version
#' }
#'
#'@section Value: \code{tibble} with STRING preferred name for protein A and B,
#'  taxon id and scores:
#' \itemize{
#'   \item \code{score} - combined score
#'   \item \code{nscore} - gene neighborhood score
#'   \item \code{fscore} - gene fusion score
#'   \item \code{pscore} - phylogenetic profile score
#'   \item \code{ascore} - coexpression score
#'   \item \code{escore} - experimental score
#'   \item \code{dscore} - database score
#'   \item \code{tscore} - textmining score
#' }
#' @examples
#' \dontrun{
#' get_net_interactions(
#'   c("ENSG00000133110", # POSTN
#'     "ENSP00000401645", # SERPINB2
#'     "CXCL10"
#'   )
#' )
#' }
#'@export
get_net_interactions <- .create_api_tsv_resp(endpoint_net_interactions)


#' Get all the STRING interaction partners of your proteins
#'
#' Diffrently from the \code{\link[pullString]{get_net_interactions}}
#' interactions between the set of input proteins and between their closest
#' interaction neighborhood (if \code{add_nodes} parameters is specified),
#' \code{get_interact_partners} fucntion provides the interactions between your
#' set of proteins and all the other STRING proteins. As STRING network usually
#' has a lot of low scoring interactions, you may want to limit the number of
#' retrieved interaction per protein using "limit" parameter (of course the high
#' scoring interactions will come first).
#'
#' @inheritParams get_string_identifiers
#' @param ... other params passed to STRING API request, options:
#'
#' @section Other arguments:
#' \itemize{
#'   \item \code{limit} - limits the number of interaction partners retrieved
#'   per protein (most confident interactions come first)
#'   \item \code{required_score} - threshold of significance to include a
#'   interaction, a number between 0 and 1000 (default depends on the network)
#'   \item \code{network_type} - options: \code{functional} (default), or \code{physical}
#'   \item \code{caller_identity} - optional, your identity for \code{STRING DB}
#'   developers. If left blank, defaults to \code{pullString} and current
#'   package version
#' }
#'
#' @inheritSection get_net_interactions Value
#' @examples
#' \dontrun{
#' get_interact_partners(c("POSTN",  "SERPINB2"))
#' }
#' @export
get_interact_partners <- .create_api_tsv_resp(endpoint_interact_partners)


#' Retrieving similarity scores of the protein set
#'
#' STRING internally uses the Smith–Waterman bit scores as a proxy for protein
#' homology. The original scores are computed by \code{SIMILARITY MATRIX OF PROTEINS
#' (SIMAP)} project. Using this API you can retrieve these scores between the
#' proteins in a selected species.
#'
#' @inheritParams get_string_identifiers
#' @section Other arguments:
#' \itemize{
#'   \item \code{caller_identity} - optional, your identity for \code{STRING DB}
#'   developers. If left blank, defaults to \code{pullString} and current
#'   package version
#' }
#' @section Details: Scores are symmetric, therefore to make the transfer a bit
#'   faster we will send only half of the similarity matrix (\code{A -> B}, but
#'   not symmetric \code{B -> A}) and the self-hits. The \code{bit score}
#'   cut-off below which we do not store or report homology is 50.
#' @section Value: \code{tibble} with score between STRING ID A and B
#' @examples
#' \dontrun{
#' get_homology(c("POSTN",  "SERPINB2"))
#' }
#' @export
get_homology <- .create_api_tsv_resp(endpoint_get_homology_scores)


#' Retrieving best similarity hits between species
#'
#' STRING internally uses the Smith–Waterman bit scores as a proxy for protein
#' homology. The original scores are computed by \code{SIMILARITY MATRIX OF PROTEINS
#' (SIMAP)} project. Using this API you can retrieve these scores between the
#' proteins in a selected species.
#'
#' @inheritParams get_string_identifiers
#' @param ... other params passed to STRING API request, options:
#' @section Other arguments:
#' \itemize{
#'   \item \code{species_b} - NCBI taxon identifier, default is \code{9606}
#'   (human)
#'   \item \code{caller_identity} - optional, your identity for \code{STRING DB}
#'   developers. If left blank, defaults to \code{pullString} and current
#'   package version
#' }
#' @export
get_best_homology <- .create_api_tsv_resp(endpoint_get_best_homology)


#' Get functional enrichment of your identifiers set
#'
#' The STRING enrichment function allows you to retrieve functional enrichment
#' for any set of input proteins. It will tell you which of your input proteins
#' have an enriched term and the term's description.
#'
#' @inheritParams get_string_identifiers
#' @param ... other params passed to STRING API request, options:
#' @section Other arguments:
#' \itemize{
#'   \item \code{caller_identity} - optional, your identity for \code{STRING DB}
#'   developers. If left blank, defaults to \code{pullString} and current
#'   package version
#' }
#' @section Details: STRING maps several databases onto its proteins, this includes:
#'   \code{Gene Ontology, KEGG pathways, UniProt Keywords, PubMed publications,
#'   Pfam domains, InterPro domains, SMART domains}. \code{NOTE:} As with other
#'   STRING APIs, we automatically expand the network by 10 proteins when a
#'   query includes only one protein. Keep in mind that this network expansion
#'   will likely reduce the FDR more than expected by chance and does not
#'   indicate an enrichment of the original single-protein set but rather of its
#'   immediate interaction neighborhood. When querying with a set of two or more
#'   proteins, no additional proteins are added to the input, and the FDR
#'   accurately reflects the probability of observing the enrichment by random
#'   chance.
#' @section Value: \code{tibble} with terms and categories, \code{p-values} and
#'   \code{FDR}
#' @export
get_enrichment <- .create_api_tsv_resp(endpoint_enrichment_tab)


#' Retrieve functional annotation
#'
#' You can retrieve all these annotations (and not only enriched subset) for
#' your proteins
#'
#' @inheritParams get_string_identifiers
#' @param ... other params passed to STRING API request, options:
#'
#' @section Other arguments:
#' \itemize{
#'   \item \code{allow_pubmed} - \code{0} or \code{1} to print also the PubMed
#'   annotations in addition to other categories, default is \code{0}
#'   \item \code{only_pubmed} - \code{0} or \code{1} to print only PubMed
#'   annotations,default is \code{0}
#'   \item \code{caller_identity} - optional, your identity for \code{STRING DB}
#'   developers. If left blank, defaults to \code{pullString} and current
#'   package version
#' }
#' @section Details: STRING maps several databases onto its proteins, this
#'   includes: \code{Gene Ontology, KEGG pathways, UniProt Keywords, PubMed
#'   publications, Pfam domains, InterPro domains, SMART domains}. \code{NOTE:}
#'   Due to the potential large size of the \code{PubMed (Reference
#'   Publications)} assignments, they won't be sent by default, but you can turn
#'   them back on by specifying the \code{allow_pubmed=1} parameter.
#' @section Value:
#'  \code{tibble} with terms and categories, number and ratio of the proteins in
#'  your input list with the term assigned
#'
#' @export
get_functional_annotation <- .create_api_tsv_resp(endpoint_get_functional_annotation)


#'Retrieve protein-protein interaction enrichment
#'
#'Even in the absence of annotated proteins (e.g. in novel genomes) STRING can
#'tell you if your subset of proteins is functionally related, that is, if it is
#'enriched in interactions in comparison to the background proteome-wide
#'interaction distribution.
#'
#'@inheritParams get_string_identifiers
#'@param ... other params passed to STRING API request, options:
#'@section Other arguments:
#' \itemize{
#'   \item \code{required_score} - threshold of significance to include a
#'   interaction, a number between 0 and 1000 (default depends on the network)
#'   in addition to other categories, default is \code{0}
#'   \item \code{only_pubmed} - \code{0} or \code{1} to print only PubMed
#'   annotations, default is \code{0}
#'   \item \code{caller_identity} - optional, your identity for \code{STRING DB}
#'   developers. If left blank, defaults to \code{pullString} and current
#'   package version
#' }
#'@export
get_ppi_enrichment <- .create_api_tsv_resp(endpoint_get_interaction_enrichment)


#'Get \code{URL} to your network
#'
#'This function allows you to get a link to your network on the STRING webpage.
#'
#'@inheritParams get_string_identifiers
#'@importFrom httr2 request req_url_path_append req_method req_body_form
#'  req_user_agent req_perform resp_body_string
#'@importFrom readr read_lines
#'@returns \code{URL} link to network with your proteins on the STRINB webpage

#' @examples
#'\dontrun{
#' get_link(
#'   c("ENSG00000133110", # POSTN
#'     "ENSP00000401645", # SERPINB2
#'     "CXCL10"
#'   )
#' )
#' }
#'@export
get_link <- function(ids, species = 9606, ...) {

  ids_req <- paste(
    ids,
    collapse = "%0d"
  )

  response <- httr2::request(base_url = base_string_url) |>
    httr2::req_url_path_append(endpoint_get_link) |>
    httr2::req_method("POST") |>
    httr2::req_body_form(
      identifiers = ids_req,
      species = 9606
    ) |>
    httr2::req_user_agent(usr_agent) |>
    httr2::req_perform() |>
    httr2::resp_body_string()

  response <- readr::read_lines(
    file = response
  )[2]

  return(response)
}


#' Get the current STRING version and its stable address
#'
#' @importFrom httr2 request req_url_path_append req_user_agent req_perform
#'   resp_body_string
#' @importFrom readr read_delim
#' @returns \code{tibble} with STRING version and current stable website URL
#'   address
#' @examples
#' \dontrun{
#' get_string_version()
#' }
#' @export
get_string_version <- function() {

  response <- httr2::request(base_string_url) |>
    httr2::req_url_path_append(endpoint_version) |>
    httr2::req_user_agent(usr_agent) |>
    httr2::req_perform() |>
    httr2::resp_body_string()

  response <- readr::read_delim(
    file = response,
    show_col_types = FALSE
  )

  return(response)
}
