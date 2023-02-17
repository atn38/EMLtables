#' Get methods
#'
#' @param corpus (list) List of EML documents, output from import_corpus
#'
#' @return (data.frame) Table of methods
#' @export
#'
#' @examples
get_methods <- function(corpus) {
  get_multilevel_element(corpus = corpus,
                         element_names = c("methods", "methodStep"),
                         parse_function = parse_methodstep)
}

#' Parse methodStep
#'
#' @param x (list) single methodStep node
#'
#' @return (data.frame) parsed node
#'
#' @examples
parse_methodstep <- function(x) {
  m <- parse_text(null2na(x$description))
data.frame(methoddescription = m[["text"]],
           methodtype = m[["type"]])
}
