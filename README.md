# `pullString` - R Interface to STRING database 

![str_highres_readme](https://github.com/user-attachments/assets/58091749-6f3a-4831-bada-445a58b14e08)

### Installation 
To install the package from GitHub, run:

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

## Usage & examples 
First, load the package and create a gene set we will use to
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


### Visualize enrichment results
To visualize your enrichment results and save `.png` file the path provided, run
`get_enrichment_plot` function. Color scales can be controlled, see
`?get_enrichment_plot` for full list of parameters
```
get_enrichment_plot(
  ids = gene_set,
  png_filename = "./string_enrichment.png"
)
```

For other enrichment/annotation tasks, look into:
```
get_functional_annotation()
get_ppi_enrichment()

```

You can get interaction partners of your list of genes and all other STRING
proteins by running:
```
get_interact_partners()
```

### Homology
If you want to find homologies across species, you can look into
`get_best_homology` and `get_homology` functions
```
get_best_homology(
  ids = "POSTN", 
  species = 9606, # human
  species_b = 10090 # mouse
)
```

STRING internally uses the Smith–Waterman bit scores as a proxy for protein
homology. The original scores are computed by SIMILARITY MATRIX OF PROTEINS
(SIMAP) project




### Retrieve and save `.png` network and enrichment plot


You can retrieve and save STRING network `.png` file on your disk:
```
get_png_network(
  ids = gene_set,
  png_filename = "./string_net.png"
)
```

Help page `?get_png_network` lists all available parameters that you can use to control the
appearance of the network, node label font size, some of them includde:
```
get_png_network(
  ids = gene_set,
  custom_label_font_size = 16,          # increase label font size, default is 12
  flat_node_design = 1,                 # disable 3D bubble design
  block_structure_pics_in_bubbles = 1,  # removes 3d protein structure pictures inside the bubble
  png_filename = "./string_net.png"
)
```


If you want to save a higher resolution `png` image, you can run the function
below with exact same arguments
```
get_highres_png_network()
```

### Get URL to STRING website with genes you provided

You can also generate a URL link to STRING website:
```
get_link(
  ids = gene_set
)
```



### Embed interactive netwwork in html Rmarkdown document:
To include interactive STRING network in your Rmarkdown document (HTML),
include these (keeping the order) in your document:

```
pullString::load_string_js()
pullString::string_request_js(ids = gene_set)
pullString::send_string_request_js()
pullString::embed_string_net()
```

**NOTE:** you can control apperance of the network, similarly as you do in 
`get_png_network` function, by adding argument to `string_request_js` function. 
Manual page lists them all `?string_request_js`. 



### Citing STRING DB:
Szklarczyk D, Kirsch R, Koutrouli M, Nastou K, Mehryary F, Hachilif R, Annika
GL, Fang T, Doncheva NT, Pyysalo S, Bork P, Jensen LJ, von Mering C.
**The STRING database in 2023: protein–protein association networks and functional enrichment analyses for any sequenced genome of interest.**
Nucleic Acids Res. 2023 Jan
6;51(D1):D638-646.[PubMed](https://pubmed.ncbi.nlm.nih.gov/36370105/)
