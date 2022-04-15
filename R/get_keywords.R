
#' Title
#'
#' @param corpus
#'
#' @return
#' @export
#'
#' @examples
get_keywords <- function(corpus) {
  vw <- list()
  for (i in seq_along(corpus)) {
    pk <- parse_packageId(names(corpus)[[i]])
    scope <- pk[["scope"]]
    id <- pk[["id"]]
    rev <- pk[["rev"]]
    klist <- list()
    if ("keywordSet" %in% names(corpus[[i]][["dataset"]])) {
      keysets <- handle_one(corpus[[i]][["dataset"]][["keywordSet"]])
      klist <-
        data.table::rbindlist(lapply(seq_along(keysets), function(x) parse_keywordset(keysets[[x]])), fill = TRUE)
      klist$id <- id
      klist$scope <- scope
      klist$rev <- rev
      klist <- subset(klist, select = c(4:6, 1:3))
    }
    vw[[i]] <- klist
  }
  return(data.table::rbindlist(vw))
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
