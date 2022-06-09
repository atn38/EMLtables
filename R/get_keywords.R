
#' Get keywords
#'
#' @param corpus (list) List of EML documents, output from import_corpus
#'
#' @return (data.frame) parsed keywords
#' @export
#'
#' @examples
get_keywords <- function(corpus) {
  get_datasetlevel_element(corpus, "keywordSet", parse_keywordset)
}

#' Parse keywordSet
#'
#' @param x (list) single keywordSet node
#'
#' @return (data.frame) parsed node
#'
#' @examples
parse_keywordset <- function(x) {
  keywords <- handle_one(x[["keyword"]])
  df <- data.table::rbindlist(lapply(seq_along(keywords), function(x) parse_keyword(keywords[[x]])))
  df$thesaurus <- null2na(x[["keywordThesaurus"]])
  return(df)
}

#' Parse keyword
#'
#' @param x (list) single keyword node
#'
#' @return (data.frame) parsed node
#'
#' @examples
parse_keyword <- function(x) {
  # sometimes there are no keyword types and the keyword list is unnamed
  if (is.null(names(x))) {
    x <- list(keyword = x)
    key_type <- NA
  } else key_type <- x[["keywordType"]]

  data.frame(
    # subscript out of bounds here. not sure why.
    keyword = x[["keyword"]],
    keywordtype = key_type,
    stringsAsFactors = F
  )
}
