#' Prepare bowtie2 indices for aligment
#'
#' Given a list of contaminant species, attempt to download genomes for each
#' contaminant and prepare a bowtie2 index for alignment
#'
#' @param contaminants [Tibble][tibble::tibble-package] listing contaminants
#' identified by decontam, with at least a 'species' column
#' @param index_dir Directory in which to store the downloaded genomes and bowtie2
#' indices
#'
#' @importFrom tibble tibble
#' @export
prepare_bowtie_indices <- function(contaminants, index_dir) {

  # Check that bowtie2 is available
  if (! fs::file_exists(Sys.which("bowtie2-build"))) {
    stop("bowtie2-build must be installed")
  }

  # Construct an organism name that will (hopefully) be recognised by RefSeq
  contaminants$organism <- stringr::str_replace_all(contaminants$species, "_", " ")
  contaminants$organism <- stringr::str_replace(contaminants$organism, "sp ", "sp. ")

  # Create index directory if it doesn't already exist
  index_dir <- fs::path(index_dir)
  if (! fs::dir_exists(index_dir)) {
    message("Creating directory ", index_dir)
    fs::dir_create(index_dir)
  }

  # Set download path for genomes
  contaminants$download_dir <- fs::path(index_dir, contaminants$species)

  # Routine to attempt to download a genome
  download_genome <- function(contaminant) {

    # Skip if genome already downloaded
    if (fs::dir_exists(contaminant$download_dir)) {
      message(
        "Skipping ",
        contaminant$species,
        " as directory ",
        contaminant$download_dir,
        " already exists (delete this directory to retry)"
      )

      # Guess fasta path
      fasta_path <- list.files(contaminant$download_dir, pattern ="\\.fna\\.gz")
      if (length(fasta_path) != 1) {
        message("Could not find fasta for ", contaminant$species)
        contaminant$fasta_path <- NA
      } else {
        contaminant$fasta_path <- fs::path(contaminant$download_dir, fasta_path)
      }

      contaminant$genome_downloaded <- TRUE
      return(contaminant)
    }

    # Attempt genome download
    fasta_path <- biomartr::getGenome(
      db = "refseq",
      organism = contaminant$organism,
      path = contaminant$download_dir,
      reference = FALSE
    )

    # Check if download was successful
    contaminant$genome_downloaded <- ! fasta_path == "Not available"
    if (! contaminant$genome_downloaded) {
      message("Download failed for ", contaminant$species)
      contaminant$fasta_path <- NA
      return(contaminant)
    }

    contaminant$fasta_path <- fs::path(contaminant$download_dir, fasta_path)
    contaminant
  }

  # Attempt download for all contaminants
  contaminants <- purrr::map_dfr(
    1:nrow(contaminants),
    ~ download_genome(contaminants[.x, ])
  )

  # Routine to run bowtie2-build on a contaminant
  build_bowtie_index <- function(contaminant) {

    # Skip if this contaminant did not have a successful genome download
    if (! contaminant$genome_downloaded) {
      message(
        "Skipping index construction for ",
        contaminant$species,
        " as genome download was not successful"
      )
      contaminant$index_built <- FALSE
      return(contaminant)
    }

    # Skip if this contaminant appears to have bowtie2 index files already
    bowtie2_files <- list.files(contaminant$download_dir, pattern ="\\.bt2")
    if (length(bowtie2_files) > 0) {
      message(
        contaminant$species,
        " appears to have index already built, skipping"
      )
      contaminant$index_built <- TRUE
      return(contaminant)
    }

    # Build output path
    output_path <- fs::path(contaminant$download_dir, contaminant$species)

    # Run bowtie2-build
    message("Running bowtie2-build for ", contaminant$species)
    system2("bowtie2-build", args = c(contaminant$fasta_path, output_path))

    # Return
    contaminant$index_built <- TRUE
    contaminant
  }
   
  # Attempt index build for all contaminants
  contaminants <- purrr::map_dfr(
    1:nrow(contaminants),
    ~ build_bowtie_index(contaminants[.x, ])
  )

  contaminants
}
