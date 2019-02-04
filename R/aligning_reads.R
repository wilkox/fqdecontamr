aligning_reads <- function(fastq_file, index) {

  # Check that fastq file exists
  if (! fs::file_exists(fastq_file)) {
    stop(fastq_file, " does not exist")
  }

  # Run bowtie2 alignment of reads against index, capturing output
  message("Running bowtie2 alignment against ", index)
  alignment <- readr::read_tsv(system2(
    "bowtie2",
    args = c("-x", index, "-U", fastq_file, "--no-unal", "--no-hd", "--no-sq"),
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

  # Return vector of reads that aligned
  alignment$read
}
