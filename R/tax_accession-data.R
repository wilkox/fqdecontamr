#' Mapping of NCBI accessions to taxonomy
#'
#' [Tibble][tibble::tibble-package] mapping NCBI reference genome accession to
#' taxonomic data.
#'
#' This data was derived from the file `markers_info.txt.bz2` in version 2.2.0
#' of [MetaPhlAn2](http://huttenhower.sph.harvard.edu/metaphlan2). The data was
#' distributed under the license included below.
#'
#' @docType data
#'
#' @format A [tibble][tibble::tibble-package] with 1,036,027 observations and 9
#' variables:
#' \describe{
#'   \item{domain}{the referenced organism's taxonomic domain}
#'   \item{phylum}{the referenced organism's taxonomic phylum}
#'   \item{class}{the referenced organism's taxonomic class}
#'   \item{order}{the referenced organism's taxonomic order}
#'   \item{family}{the referenced organism's taxonomic family}
#'   \item{genus}{the referenced organism's taxonomic genus}
#'   \item{species}{the referenced organism's taxonomic species}
#'   \item{type}{the referenced organism's taxonomic type}
#'   \item{accession}{the NCBI accession form the referenced organism's genome}
#' }
#'
#' @references Nicola Segata, Levi Waldron, Annalisa Ballarini, Vagheesh
#' Narasimhan, Olivier Jousson, Curtis Huttenhower. 
#' Nature Methods, 8, 811–814, 2012
#'
#' @source MetaPhlAn2 version 2.2.0.
#' \url{http://huttenhower.sph.harvard.edu/metaphlan2}
#'
#' @section License:
#'
#' Copyright (c) 2015, Duy Tin Truong, Nicola Segata and Curtis Huttenhower
#' 
#' Permission is hereby granted, free of charge, to any person obtaining a copy
#' of this software and associated documentation files (the "Software"), to
#' deal in the Software without restriction, including without limitation the
#' rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
#' sell copies of the Software, and to permit persons to whom the Software is
#' furnished to do so, subject to the following conditions:
#' 
#' The above copyright notice and this permission notice shall be included in
#' all copies or substantial portions of the Software.
#' 
#' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#' IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#' FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#' AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#' LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
#' FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
#' IN THE SOFTWARE.
#'
"tax_accession"
