#' Align reads from a fastq file against a bowtie2 index
#'
#' @param fastq_file Path of the fastq file to be aligned
#' @param index_path Path of the bowtie2 index
#' @param species Name of the contaminant species
align_reads <- function(fastq_file, index_path, species) {

  # Skip if index is missing
  if (is.na(index_path)) {
    return(tibble(read = character(), species = character()))
  }

  # Check that fastq file exists
  if (! fs::file_exists(fastq_file)) {
    stop(fastq_file, " does not exist")
  }

  # Run bowtie2 alignment of reads against index, capturing output
  message("Running bowtie2 alignment against ", index_path)
  alignment <- readr::read_tsv(system2(
    "bowtie2",
    args = c("-x", index_path, "-U", fastq_file, "--no-unal", "--no-hd", "--no-sq"),
    stdout = TRUE
  ), col_names = c(
    "read",
    "flags",
    "reference_seq",
    "start_pos",
    "map_quality",
    "alignment",
    "mate",
    "end_pos",
    "frag_length",
    "read_seq",
    "read_qual",
    "opt1",
    "opt2",
    "opt3",
    "opt4",
    "opt5",
    "opt6",
    "opt7",
    "opt8",
    "opt9"
  ))

  # Return reads that aligned
  reads <- tibble::tibble(read = alignment$read)
  reads$species <- rep(species, nrow(reads))
  reads
}