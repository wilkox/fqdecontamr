#' Remove contaminant reads from a fastq file
#'
#' @param fastq_file Path to the fastq file to be filtered. Can be in '.gz'
#' compressed format
#' @param decontam_file Path to decontam output, in .xlsx format
#' @param index_dir Directory in which to store downloaded genomes and bowtie2
#' indices
#' @param out_file Path to which the filtered fastq should be written
#' @param threads How many threads should bowtie2 use when aligning (default 1)
#'
#' @return Returns a [tibble][tibble::tibble-package] of reads that have been
#' removed and their taxonomic assignments
#'
#' @importFrom tibble tibble
#' @export
decontaminate <- function(
  fastq_file,
  decontam_file,
  index_dir,
  out_file,
  threads = 1
) {

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
  contaminants <- dplyr::select(contaminants, species = "Species")

  # Download contaminant genomes
  contaminants <- purrr::map_dfr(contaminants$species, download_genome, index_dir)

  # Prepare bowtie2 indices for contaminant genomes
  contaminants$index_path <- purrr::pmap(contaminants, prepare_bowtie_index)

  # Get list of reads that align against each contaminant genome
  message("Aligning reads...")
  contaminant_reads <- purrr::map2_dfr(
    contaminants$index_path,
    contaminants$species,
    ~ align_reads(fastq_file, .x, .y, threads = threads)
  )

  # Stop if out file exists
  if (fs::file_exists(out_file)) {
    stop(out_file, " already exists")
  }

  # Load the fastq file
  message("Loading fastq...")
  fastq <- ShortRead::readFastq(fastq_file)

  # Remove contaminant reads
  message("Removing contaminant reads...")
  fastq <- fastq[! as.character(ShortRead::id(fastq)) %in% contaminant_reads$read, ]

  # Write fastq to file
  message("Writing filtered fastq...")
  ShortRead::writeFastq(fastq, out_file, compress = FALSE)

  contaminant_reads
}
