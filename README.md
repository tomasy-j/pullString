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

