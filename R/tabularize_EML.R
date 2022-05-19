#' Convert a corpus of EML documents into tables
#'
#' @param path (character) Path to directory with EML documents in .xml file format.
#'
#' @return (list) List of data.frames
#' @export
#'
#' @examples
EML2df <- function(corpus) {
  # corp <- import_corpus(path)
  stopifnot(is.list(corpus), !is.null(names(corpus)))
  tbls <- list(
    datasets = try(get_dataset(corpus)),
    entities = try(get_entities(corpus)),
    attributes = try(get_attributes(corpus)),
    codes = try(get_attribute_codes(corpus)),
    parties = try(get_parties(corpus)),
    keywords = try(get_keywords(corpus)),
    changehistory = try(get_changehistory(corpus)),
    geocov = try(get_coverage_geo(corpus)),
    tempocov = try(get_coverage_tempo(corpus)),
    taxcov = try(get_coverage_tax(corpus)),
    projects = try(get_project(corpus)),
    annotations = try(get_annotations(corpus)),
    methods = try(get_methods(corpus))
  )
  return(tbls)
}
