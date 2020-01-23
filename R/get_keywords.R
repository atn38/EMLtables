#'
#'
#'
#'
#'
#'
#'
#'
#'
#'
#'
#'
#'
#'
#'

get_keywords <- function(corpus) {
  vw_keywords <- data.frame()
  keysetss <- list()

  for (i in seq_along(corpus)) {
    pk <- get_pk(names(corpus)[[i]])
    scope <- pk[["scope"]]
    id <- pk[["id"]]
    rev <- pk[["rev"]]

    keysets <- corpus[[i]][["dataset"]][["keywordSet"]]
    if (!is.null(names(keysets))) keysets <- list(keysets)
    for (j in seq_along(keysets)) {
      thesaurus <- keysets[[j]][["keywordThesaurus"]]
      if (is.null(thesaurus))
        thesaurus <- "none"

      keywords <- keysets[[j]][["keyword"]]
      if (!is.null(names(keywords))) keywords <- list(keywords)
      # return(keywords)
      for (k in seq_along(keywords)){
      keyk <- keywords[[k]]

      # sometimes there are no keyword types and the keyword list is unnamed
      if (is.null(names(keyk))) {
        keyk <- list(keyword = keyk)
        key_type <- NA
      } else key_type <- keyk[["keywordType"]]


        keydf <- data.frame(
          scope = scope,
          id = id,
          rev = rev,

          # subscript out of bounds here. not sure why.
          keyword = keyk[["keyword"]],
          keywordtype = key_type,
          keyword_thesaurus = thesaurus,
          stringsAsFactors = F
        )

        vw_keywords <- rbind(vw_keywords, keydf)
      }
    }
    # keysetss <- c(keysetss, keysets)

  }
  return(vw_keywords)
}
