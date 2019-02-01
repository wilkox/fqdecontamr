#' Remove contaminant reads from a fastq file
#'
#' @param fastq_file Path to the fastq file to be filtered. Can be in '.gz'
#' compressed format
#' @param bowtie_file Path to bowtie2 output. Can be in '.bz2' compressed format
#' @param decontam_file Path to decontam output, in .xlsx format
#' @param out_file Path to which the filtered fastq should be written
#'
#' @return Returns a [tibble][tibble::tibble-package] of reads that have been
#' removed and their taxonomic assignments
#'
#' @importFrom tibble tibble
#' @export
decontaminate <- function(fastq_file, bowtie_file, decontam_file, out_file) {

  # Load reads from the bowtie output
  message("Loading bowtie output...")
  reads <- readr::read_tsv(bowtie_file, col_names = c("read", "ref"))

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

  # Load the decontam output
  message("Loading decontam output...")
  contaminants <- readxl::read_excel(decontam_file)

  # Check that the decontam file is in the expected format
  if (! all(names(contaminants) == c("Species", "freq", "prev", "p.freq", "p.prev", "p", "contaminant"))) {
    stop("decontam file ", decontam_file, " is not in the expected format")
  }

  # Select only the contaminant species
  contaminants <- contaminants[contaminants$contaminant, ]

  # Check that all the contaminant species are known in `ref_to_tax`
  if (! all(contaminants$Species %in% ref_to_tax$species)) {
    message("NOTE: These contaminant species are unknown and will not be removed")
    print(contaminants[! contaminants$Species %in% ref_to_tax$species, ]$Species)
  }

  # Select only reads to be removed
  message("Loading fastq...")
  reads <- reads[reads$species %in% contaminants$Species, ]

  # Load the fastq file
  fastq <- ShortRead::readFastq(fastq_file)

  # Identify reads to be removed
  message("Identifying contaminant reads...")
  removed_reads <- as.character(id(fastq)[id(fastq) %in% reads$read, ])

  # Remove contaminant reads
  message("Filtering fastq...")
  fastq <- fastq[! id(fastq) %in% reads$read, ]

  # Write fastq to file
  message("Writing filtered fastq...")
  ShortRead::writeFastq(fastq, out_file)

  # Compile list of removed reads and return
  removed_reads <- reads[reads$read %in% removed_reads, ]

  removed_reads
}
