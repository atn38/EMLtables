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
    scope <- sub("\\..*$", "", names(corpus)[[i]])

    # get string between the two periods -- datasetid
    id <- str_extract(names(corpus), "(?<=\\.)(.+)(?=\\.)")[[i]]

    # get string after last period -- revision

    rev <- sub(".*\\.", "", names(corpus))[[i]]

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
        key <- data.frame(
          scope = scope,
          id = id,
          rev = rev,
          keyword = keywords[[k]][["keyword"]],
          keywordtype = keywords[[k]][["keywordType"]],
          thesaurus = thesaurus,
          stringsAsFactors = F
        )

        vw_keywords <- rbind(vw_keywords, key)
      }
    }
    # keysetss <- c(keysetss, keysets)

  }
  return(vw_keywords)
}
