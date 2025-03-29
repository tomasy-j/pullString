# `pullString` - R Interface to STRING database


### Installation

To install the package from GitHub, run:
```
devtools::install_github("tomasy-j/pullString")
```

**Before you start coding:**
- Be considerate: when submitting requests in a `for` loop, it's a good practice
to add `Sys.sleep(1)` after each call, so that server won't get
overloaded.
- Although STRING understands a variety of identifiers and does its best to
disambiguate your input it is recommeded to map your identifier first (see:
mapping). Querying the API with a disambiguated identifier (for example
`9606.ENSP00000269305` for human `TP53`) will guarantee much faster server 
response.
- Another way to guarantee faster server response is to specify from which
species your proteins come from (see 'species' parameter). In fact API will
reject queries for networks larger than 10 proteins without the specified
organism.
- Current STRING version is 12.0 (https://version-12-0.string-db.org)


## Usage & examples

First, load the package and create a gene set we will use to query STRING
database
```
library(pullString)
gene_set <- c("POSTN", "IRF1", "CXCL10", "IFNA1", "SERPINB2", "OAS1")
```


### Check current version

check the current STRING database version
```
get_string_version()
```



```
get_string_identifiers
get_net_interactions
```




```
get_enrichment
get_functional_annotation
get_ppi_enrichment
```



### Other functions:
```
get_interact_partners
get_homology
get_best_homology
```



### Retrieve and save `.png` network and enrichment plot

```
get_png_network
get_enrichment_plot
```




### Embed interactive netwwork in html Rmarkdown document:

```
get_link

load_string_js
string_request_js
send_string_request_js
embed_string_net
```






