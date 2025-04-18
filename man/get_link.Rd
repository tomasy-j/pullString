% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_tsv_response.R
\name{get_link}
\alias{get_link}
\title{Get \code{URL} to your network}
\usage{
get_link(ids, species = 9606, ...)
}
\arguments{
\item{ids}{character vector of identifiers, can be protein names, synonyms,
ensembl id, ensemble protein id, HGNC symbol, UniProt or mixed}

\item{species}{NCBI/STRING taxon, default \code{9606} (human)}

\item{...}{other params passed to \code{STRING API} request, options:}
}
\value{
\code{URL} link to network with your proteins on the STRINB webpage
}
\description{
This function allows you to get a link to your network on the STRING webpage.
}
\examples{
\dontrun{
get_link(
  c("ENSG00000133110", # POSTN
    "ENSP00000401645", # SERPINB2
    "CXCL10"
  )
)
}
}
