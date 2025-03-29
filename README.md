# `pullString` - R Interface to STRING database 

![str_highres_readme](https://github.com/user-attachments/assets/58091749-6f3a-4831-bada-445a58b14e08)

### Installation 
To install the package from GitHub, run:


### Installation To install the package from GitHub, run:

```
devtools::install_github("tomasy-j/pullString")
```

**Before you start coding:**
- Be considerate: when submitting requests in a `for` loop, it's a good practice
to add `Sys.sleep(1)` after each call, so that server won't get overloaded.
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
## Usage & examples First, load the package and create a gene set we will use to
query STRING database
```
library(pullString)
gene_set <- c("POSTN", "IRF1", "CXCL10", "IFNA1", "SERPINB2", "OAS1")
```

**NOTE:** For more details on each function and full parameter list, look up help pages,
e.g. `?get_net_interactions`
### Check current version to check the current STRING database version, run this
function:
```
get_string_version()
```

### Mapping identifiers You can map your various identifiers like gene ensembl
id, HGNC symbol, protein symbol, etc. onto the STRING protein/gene names by
calling:
```
get_string_identifiers(ids = gene_set)
```

This will return all the STRING genes/proteins that were mapped to your input
and their descriptive annotation. As said earlier, using identifiers that are
readily understood by STRING, can make querying faster.
By default, this function uses `species = 9606` (human). You can browse all
available
[organisms](https://string-db.org/cgi/input?sessionId=bGTsZdRLTigv&input_page_active_form=organisms)
and use their taxon id in the function call.

You can retrieve your STRING interaction network for one or multiple proteins.
It will tell you the combined score and all the channel specific scores for the
set of proteins. You can also extend the network neighborhood by setting
add_nodes, which will add, to your network, new interaction partners in order of
their confidence.

Adding `required_score` parameter, will put a threshold of significance to
include an interaction. You can retrieve either `functional` or `physical`
network types. The dafult is `functional`.
```
get_net_interactions(
  ids = gene_set,
  required_score = 800,
  network_type = "functional"
)
```


### Enrichment analysis
Using `pullString` you can also perform functional enrichment analysis.

STRING maps several databases onto its proteins, this includes: Gene Ontology,
KEGG pathways, UniProt Keywords, PubMed publications, Pfam domains, InterPro
domains, and SMART domains.

This function returns enrichment analysis results table as well as statistics
for each enriched term
```
get_enrichment(ids = gene_set)
```

For other enrichment/annotation tasks, look into:
```
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
get_highres_png_network
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


### Citing STRING DB:
Szklarczyk D, Kirsch R, Koutrouli M, Nastou K, Mehryary F, Hachilif R, Annika
GL, Fang T, Doncheva NT, Pyysalo S, Bork P, Jensen LJ, von Mering C.
**The STRING database in 2023: protein–protein association networks and functional enrichment analyses for any sequenced genome of interest.**
Nucleic Acids Res. 2023 Jan
6;51(D1):D638-646.[PubMed](https://pubmed.ncbi.nlm.nih.gov/36370105/)
