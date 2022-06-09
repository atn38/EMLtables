
#' Title
#'
#' @param corpus (list) List of EML documents, output from import_corpus
#'
#' @return (data.frame) Table of change history metadata
#' @export
#'
#' @examples
get_changehistory <- function(corpus) {
get_datasetlevel_element(corpus = corpus,
                         element_names = c("maintenance", "changeHistory"),
                         parse_function = parse_changehistory)
}

#' Title
#'
#' @param x (list) changeHistory node
#'
#' @return (data.frame) parsed change history
#'
#' @examples
parse_changehistory <- function(x) {
  data.frame(
    change_scope = null2na(x[["changeScope"]]),
    date = null2na(x[["changeDate"]]),
    old_value = null2na(x[["oldValue"]]),
    new_value = null2na(x[["newValue"]]),
    note = null2na(x[["comment"]])
  )
}
