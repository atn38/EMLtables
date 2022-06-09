#' Title
#'
#' @param corpus (list) list of EML documents, output from import_corpus
#'
#' @return (data.frame) Table of annotation metadata from dataset, entity, and/or attribute
#' @export
#'
#' @examples
get_annotations <- function(corpus) {
  get_multilevel_element(corpus = corpus, element_name = "annotation", parse_function = parse_annotation)
}

#' Title
#'
#' @param x (list) single annotation node
#'
#' @return (data.frame) table of parsed annotation
#'
#' @examples
parse_annotation <- function(x) {
  return(
    data.frame(
      stringsAsFactors = F,
      propertylabel = x$propertyURI$label,
      propertyURI = x$propertyURI$propertyURI,
      valuelabel = x$valueURI$label,
      valueURI = x$valueURI$valueURI
    )
  )
}
