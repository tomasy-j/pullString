# `pullString` - R Interface to STRING database


### Installation

```
devtools::install_github("BIGslu/pullString")
```

### Examples

```
gene_set <- c("POSTN", "IRF1", "CXCL10", "IFNA1")

pullString::get_string_png(
  gene = gene_set,
  png_filename = "./string_net.png"
)

pullString::get_enr(
  gene = gene_set
)
```


- Be considerate: when submitting requests in a `for` loop, it's considered a
good practice to add `Sys.sleep(1)` after each call, so that server won't get
overloaded.
- Although STRING understands a variety of identifiers and does its best to
disambiguate your input it is recommeded to map your identifier first (see:
mapping). Querying the API with a disambiguated identifier (for example
9606.ENSP00000269305 for human TP53) will guarantee much faster server response.
- Another way to guarantee faster server response is to specify from which
species your proteins come from (see 'species' parameter). In fact API will
reject queries for networks larger than 10 proteins without the specified
organism.
- Current STRING version is 12.0 (https://version-12-0.string-db.org)

