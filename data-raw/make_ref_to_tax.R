make_ref_to_tax <- function(markers_info_file) {

  # Load reference to taxonomy mapping
  ref_to_tax <- readr::read_tsv(
    markers_info_file,
    col_names = c("ref", "taxonomy")
  )

  # Extract taxonomic information and tidy it
  ref_to_tax$tax <- stringr::str_match(
    ref_to_tax$taxonomy,
    "'taxon': '(.+)'\\}$"
  )[, 2]
  ref_to_tax$tax <- stringr::str_remove_all(tax, ".__")
  ref_to_tax <- tidyr::separate(
    ref_to_,
    tax,
    into = c(
      "domain",
      "phylum",
      "class",
      "order",
      "family",
      "genus",
      "species",
      "type"
    ),
    sep = "\\|"
  )
  ref_to_tax$taxonomy <- NULL

  ref_to_tax
}
