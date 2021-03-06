% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/decontaminate.R
\name{decontaminate}
\alias{decontaminate}
\title{Remove contaminant reads from a fastq file}
\usage{
decontaminate(fastq_file, decontam_file, index_dir, out_file,
  threads = 1)
}
\arguments{
\item{fastq_file}{Path to the fastq file to be filtered. Can be in '.gz'
compressed format}

\item{decontam_file}{Path to decontam output, in .xlsx format}

\item{index_dir}{Directory in which to store downloaded genomes and bowtie2
indices}

\item{out_file}{Path to which the filtered fastq should be written}

\item{threads}{How many threads should bowtie2 use when aligning (default 1)}
}
\value{
Returns a [tibble][tibble::tibble-package] of reads that have been
removed and their taxonomic assignments
}
\description{
Remove contaminant reads from a fastq file
}
