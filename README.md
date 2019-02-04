
fqdecontamr filters fastq files to remove reads identified as potential
contaminants by [decontam](https://benjjneb.github.io/decontam/).

## Installation

You can install the development version of fqdecontamr from
[GitHub](https://github.com/wilkox/fqdecontamr) with:

``` r
devtools::install_github("wilkox/fqdecontamr")
```

## How to use

fqdecontamr requires three input files:

  - The bowtie2 output produced by
    [MetaPhlAn2](http://huttenhower.sph.harvard.edu/metaphlan2), which
    maps reads to NCBI references (bzip2 compressed files are accepted)
  - The decontam output, in the form of a Microsoft Excel spreadsheet
    (`*.xlsx`)
  - The fastq file you want to filter (gzip compressed files are
    accepted)

The main function provided by fqdecontamr is called `decontaminate()`.
It takes as arguments the paths to the three input files listed above
(`bowtie_file`, `decontam_file` and `fastq_file`), and a fourth argument
giving the path for the filtered fastq file. As output, it produces a
[tibble](https://tibble.tidyverse.org) listing the reads that were
removed.

To map NCBI references to species names, fqdecontamr uses a built-in
dataset (`tax_accession`) derived from the `markers_info.txt.bz2` file
distributed with MetaPhlAn2. The current version of this dataset is
derived from MetaPhlAn2 version 2.2.0. This dataset is quite big, which
is why fqdecontamr can take a while to load.
