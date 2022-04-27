#' Title
#'
#' @param corpus
#'
#' @return
#' @export
#'
#' @examples
get_project <- function(corpus) {
  get_datasetlevel_element(corpus, "project", parse_project)
}

#' Title
#'
#' @param x
#'
#' @return
#'
#' @examples
parse_project <- function(x){
  data.frame(
  title = x[["title"]],
  abstract = parse_text(null2na(x[["abstract"]]))[["text"]],
  funding = parse_text(null2na(x[["funding"]]))[["text"]]
  )
}
