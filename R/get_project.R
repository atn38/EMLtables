#' Get project information
#'
#' @param corpus (list) List of EML documents, output from import_corpus
#'
#' @return (data.frame) Table of project information
#' @export
#'
#' @examples
get_project <- function(corpus) {
  get_datasetlevel_element(corpus, "project", parse_project)
}

#' parse project node
#'
#' @param x (list) single project node
#'
#' @return (data.frame) parsed node
#'
#' @examples
parse_project <- function(x){
  data.frame(
  title = x[["title"]],
  abstract = parse_text(null2na(x[["abstract"]]))[["text"]],
  funding = parse_text(null2na(x[["funding"]]))[["text"]]
  )
}
