#' Prepare a bowtie2 index
#'
#' @param fasta_path Path of the fasta file from which to prepare the index
#' @param dir Directory in which to store the index
#' @param species Name of the contaminant species
#' @param ... Other arguments that will be ignored
prepare_bowtie_index <- function(fasta_path, dir, species, ...) {

  # Check that bowtie2 is available
  if (! fs::file_exists(Sys.which("bowtie2-build"))) {
    stop("bowtie2-build must be installed")
  }

  # Skip if no fasta is available
  if (is.na(fasta_path)) {
    message(
      "Skipping index construction for ",
      species,
      " as genome download was not successful"
    )
    index_path <- NA
    return(index_path)
  }

  # Build path for index
  index_path <- fs::path(dir, species)

  # Skip if this contaminant appears to have bowtie2 index files already
  if (length(list.files(dir, pattern ="\\.bt2") > 0)) {
    message(species, " appears to have index already built, skipping")
    return(index_path)
  }

  # Run bowtie2-build
  message("Running bowtie2-build for ", species)
  system2("bowtie2-build", args = c(fasta_path, index_path))

  # Return
  index_path
}
