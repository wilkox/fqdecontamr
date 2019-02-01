#' Remove contaminant reads from a fastq file
#'
#' @param bowtie_file Path to bowtie2 output. Can be in '.bz2' compressed format
#'
#' @export
decontaminate <- function(bowtie_file) {

  reads <- read.delim(
    bowtie_file,
    header = FALSE,
    sep = "\t",
    col.names = c("read", "ref"),
    stringsAsFactors = FALSE
  )

  # Check that reads are unique
  if (! length(unique(reads$read)) == nrow(reads)) {
    warning("Non-unique reads in ", file)
  }

  # Check that all taxonomic references are in `ref_to_tax`
  if (! all(reads$ref %in% ref_to_tax$ref)) {
    warning("The bowtie2 file contains some unknown sequence references")
  }

  # Merge in the taxonomic assignments
  reads <- merge(reads, ref_to_tax, by = "ref", all.x = TRUE)


}
