#' Title
#'
#' @param corpus
#'
#' @return
#' @export
#'
#' @examples
get_annotations <- function(corpus) {
  get_multilevel_element(corpus = corpus, element_name = "annotation", parse_function = parse_annotation)
}

#' Title
#'
#' @param x (list) annotation node
#'
#' @return
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
