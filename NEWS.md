# v0.0.0.9006

## Bug fixes

- Fix error when bowtie2 returns no alignments

# v0.0.0.9005

# Minor changes

- Slight change to processing of bowtie2 alignment output to work around
  bowtie2 error
- Change to biomartr version requirement due to strange versioning of biomartr

# v0.0.0.9004

# Major changes

- Add threads argument to control number of threads used by bowtie2

# v0.0.0.9003

# Major changes

- Add check to genome downloading to prevent re-attempting failed downloads

# v0.0.0.9002

# Major changes

- Change approach to use bowtie2 alignments against reference contaminant
  genomes

# v0.0.0.9001

## Bug fixes

- Fix various small bugs
- Add check for existence of `out_file` at start of `decontaminate()`

# fqdecontamr 0.0.0.9000

- Added a `NEWS.md` file to track changes to the package.
