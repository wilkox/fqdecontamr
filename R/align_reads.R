#' Align reads from a fastq file against a bowtie2 index
#'
#' @param fastq_file Path of the fastq file to be aligned
#' @param index_path Path of the bowtie2 index
#' @param species Name of the contaminant species
#' @param threads How many threads should bowtie2 use (default 1)
align_reads <- function(fastq_file, index_path, species, threads = 1) {

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
  outfile <- tempfile(pattern = "file", tmpdir = tempdir(), fileext = "")
  system2("bowtie2", args = c(
    "-x",
    index_path,
    "-U",
    fastq_file,
    "--no-unal",
    "--no-hd",
    "--no-sq",
    "-p",
    threads,
    "-S",
    outfile
  ))
  if (fs::is_file_empty(outfile)) {
    message("No reads aligned for this query")
    return()
  }
  alignment <- readr::read_tsv(outfile, col_names = c(
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
  fs::file_delete(outfile)

  # Return reads that aligned
  reads <- tibble::tibble(read = alignment$read)
  reads$species <- rep(species, nrow(reads))
  reads
}
