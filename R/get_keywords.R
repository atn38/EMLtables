
#' Title
#'
#' @param corpus
#'
#' @return
#' @export
#'
#' @examples
get_keywords <- function(corpus) {
  get_datasetlevel_element(corpus, "keywordSet", parse_keywordset)
}

#' Title
#'
#' @param x
#'
#' @return
#'
#' @examples
parse_keywordset <- function(x) {
  keywords <- handle_one(x[["keyword"]])
  df <- data.table::rbindlist(lapply(seq_along(keywords), function(x) parse_keyword(keywords[[x]])))
  df$thesaurus <- null2na(x[["keywordThesaurus"]])
  return(df)
}

#' Title
#'
#' @param x
#'
#' @return
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
