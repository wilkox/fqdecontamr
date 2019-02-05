#' Download a genome from RefSeq
#'
#' @param species Name of the species to download
#' @param index_dir Directory in which downloaded genomes should be cached
download_genome <- function(species, index_dir) {

  message("Attempting to download genome for ", species)

  contaminant <- tibble::tibble(species = species)

  # Construct an organism name that will (hopefully) be recognised by RefSeq
  contaminant$organism <- stringr::str_replace_all(contaminant$species, "_", " ")
  contaminant$organism <- stringr::str_replace(contaminant$organism, "sp ", "sp. ")

  # Create index directory if it doesn't already exist
  index_dir <- fs::path(index_dir)
  if (! fs::dir_exists(index_dir)) {
    message("Creating directory ", index_dir)
    fs::dir_create(index_dir)
  }

  # Set download path for genomes
  contaminant$dir <- fs::path(index_dir, contaminant$species)

  # If the directory already exists
  if (fs::dir_exists(contaminant$dir)) {

    # Try to find fasta file
    fasta_path <- list.files(contaminant$dir, pattern ="\\.fna\\.gz")

    # If the fasta file exists, return
    if (length(fasta_path) == 1) {
      contaminant$fasta_path <- fs::path(contaminant$dir, fasta_path)
      message(contaminant$species, " already downloaded")
      return(contaminant)

    # If it doesn't exist, delete the directory and continue
    } else {
      message("Deleting directory ", contaminant$dir)
      fs::dir_delete(contaminant$dir)
    }
  }

  # Attempt genome download
  fasta_path <- biomartr::getGenome(
    db = "refseq",
    organism = contaminant$organism,
    path = contaminant$dir,
    reference = FALSE
  )

  # Check if download was successful
  if (fasta_path == "Not available") {
    message("Download failed for ", contaminant$species)
    contaminant$fasta_path <- NA
    return(contaminant)
  }

  # If successful, set the path and return
  contaminant$fasta_path <- fs::path(fasta_path)

  contaminant
}
