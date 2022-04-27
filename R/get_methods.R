#' Title
#'
#' @param x
#'
#' @return
#' @export
#'
#' @examples
get_methods <- function(corpus) {
  get_multilevel_element(corpus = corpus,
                         element_names = c("methods", "methodStep"),
                         parse_function = parse_methodstep)
}

#' Title
#'
#' @param x
#'
#' @return
#'
#' @examples
parse_methodstep <- function(x) {
  m <- parse_text(null2na(x$description))
data.frame(methoddescription = m[["text"]],
           methodtype = m[["type"]])
}
