#' Get taxonomic coverage
#'
#' @param corpus (list) List of EML documents, output from import_corpus
#'
#' @return (data.frame) table of taxonomic coverage metadata. Since taxonomicClassification can be recursively nested, each taxonomicClassification node gets its own row.
#' @export
#'
#' @examples
get_coverage_tax <- function(corpus) {
  get_multilevel_element(
    corpus = corpus,
    element_names = c("coverage", "taxonomicCoverage"),
    parse_function = parse_taxcov
  )
}

#' @param x (list) single taxonomicCoverage node
#'
#' @return (data.frame) parsed node
#'
#' @examples
parse_taxcov <- function(x) {
  a <- handle_one(x$taxonomicClassification)
  return(data.table::rbindlist(
    lapply(seq_along(a), function(x)
      parse_taxonomic_classification(a[[x]], i = x)),
    fill = TRUE
  ))
}

#' Title
#'
#' @param x
#' @param i
#' @param j
#'
#' @return
#'
#' @examples
parse_taxonomic_classification <- function(x, i, j) {
  t <- list()
  j <- i
  if ("taxonomicClassification" %in% names(x)) {
    i <- i + 1
    t[[j]] <-
      data.frame(
        taxonrecordid = i,
        parenttaxonid = j,
        taxonrankname = null2na(x$taxonRankName),
        taxonrankvalue = null2na(x$taxonRankValue),
        commonname = handle_multiple(null2na(x$commonname)),
        taxonid = handle_multiple(null2na(x$taxonId$taxonId)),
        taxonidprovider = handle_multiple(null2na(x$taxonId$provider))
      )
    j <- j + 1
    a <- handle_one(x$taxonomicClassification)
    t[[j]] <- data.table::rbindlist(lapply(seq_along(a), function(x) parse_taxonomic_classification(a[[x]], i = i, j = j)), fill = TRUE)
  } else {
      t[[j]] <-
      data.frame(
        taxonrecordid = i,
        parenttaxonid = j,
        taxonrankname = null2na(x$taxonRankName),
        taxonrankvalue = null2na(x$taxonRankValue),
        commonname = handle_multiple(null2na(x$commonname)),
        taxonid = handle_multiple(null2na(x$taxonId$taxonId)),
        taxonidprovider = handle_multiple(null2na(x$taxonId$provider)))
  }
  return(data.table::rbindlist(t, fill = TRUE))
}
