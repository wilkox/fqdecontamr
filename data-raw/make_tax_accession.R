make_tax_accession <- function(markers_info_file) {

  # Load markers info file from MetaPhlAn2
  tax_accession <- readr::read_tsv(
    markers_info_file,
    col_names = c("ref", "taxonomy")
  )

  # Extract taxonomic information and tidy it
  tax_accession$tax <- stringr::str_match(
    tax_accession$taxonomy,
    "'taxon': '(.+)'\\}$"
  )[, 2]
  tax_accession$tax <- stringr::str_remove_all(tax_accession$tax, ".__")
  tax_accession <- tidyr::separate(
    tax_accession,
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
  tax_accession$taxonomy <- NULL

  # Parse genome/assembly accession from reference string
  tax_accession$accession <- stringr::str_split_fixed(tax_accession$ref, "\\|", 5)[, 4]
  tax_accession$ref <- NULL

  # Keep only unique rows
  tax_accession <- dplyr::distinct(tax_accession)

  tax_accession
}
