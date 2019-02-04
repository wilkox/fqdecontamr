#' Remove contaminant reads from a fastq file
#'
#' @param decontam_file Path to decontam output, in .xlsx format
#' @param fastq_file Path to the fastq file to be filtered. Can be in '.gz'
#' compressed format
#' @param out_file Path to which the filtered fastq should be written
#' @param index_dir Directory in which to store downloaded genomes and bowtie2
#' indices
#'
#' @return Returns a [tibble][tibble::tibble-package] of reads that have been
#' removed and their taxonomic assignments
#'
#' @importFrom tibble tibble
#' @export
decontaminate <- function(fastq_file, decontam_file, index_dir, out_file) {

  # Load and tidy the decontam output
  message("Loading decontam output...")
  contaminants <- readxl::read_excel(decontam_file)
  if (! all(names(contaminants) == c(
    "Species",
    "freq",
    "prev",
    "p.freq",
    "p.prev",
    "p",
    "contaminant"
  ))) {
    stop("decontam file ", decontam_file, " is not in the expected format")
  }
  contaminants <- contaminants[contaminants$contaminant, "Species"]
  contaminants <- dplyr::select(contaminants, species = Species)

  # Prepare bowtie2 indices for contaminant genomes
  message("Preparing bowtie2 indices...")
  contaminants <- prepare_bowtie_indices(contaminants, index_dir)

  # Get list of reads that align against each contaminant genome
  message("Aligning reads...")
  contaminant_reads <- purrr::map2(
    contaminants[contaminants$index_built, ]$download_dir,
    contaminants[contaminants$index_built, ]$species,
    ~ aligning_reads(fastq_file, fs::path(.x, .y))
  )
  contaminant_reads <- purrr::set_names(contaminant_reads, contaminants$species)

  stop()

  # Stop if out file exists
  if (fs::file_exists(out_file)) {
    stop(out_file, " already exists")
  }

  # Select only reads to be removed
  message("Loading fastq...")
  reads <- reads[reads$species %in% contaminants$Species, ]

  # Load the fastq file
  fastq <- ShortRead::readFastq(fastq_file)

  # Identify reads to be removed
  message("Identifying contaminant reads...")
  removed_reads <- as.character(ShortRead::id(fastq))[as.character(ShortRead::id(fastq)) %in% reads$read]

  # Remove contaminant reads
  message("Filtering fastq...")
  fastq <- fastq[! as.character(ShortRead::id(fastq)) %in% removed_reads, ]

  # Write fastq to file
  message("Writing filtered fastq...")
  ShortRead::writeFastq(fastq, out_file, compress = FALSE)

  # Compile list of removed reads and return
  removed_reads <- tibble::as_tibble(reads[reads$read %in% removed_reads, ])

  removed_reads
}
