#'
#'
#'
#'
#'
#'


get_coverage_tempo <- function(corpus) {
  vw_cov_temp <- data.frame()

  for (i in seq_along(corpus)) {
    scope <- sub("\\..*$", "", names(corpus)[[i]])

    # get string between the two periods -- datasetid
    id <- str_extract(names(corpus), "(?<=\\.)(.+)(?=\\.)")[[i]]

    # get string after last period -- revision

    rev <- sub(".*\\.", "", names(corpus))[[i]]

    covs <-
      corpus[[i]][["dataset"]][["coverage"]][["temporalCoverage"]]
    if (!is.null(names(covs)))
      covs <- list(covs)

    for (j in seq_along(covs)) {
      cov <- covs[[j]]

      covdf <- data.frame(
        stringsAsFactors = F,
        scope = scope,
        id = id,
        rev = rev,
        begin = na_if_null(cov[["rangeOfDates"]][["beginDate"]][["calendarDate"]]),
        end = na_if_null(cov[["rangeOfDates"]][["endDate"]][["calendarDate"]])
      )

      vw_cov_temp <- rbind(vw_cov_temp, covdf)
    }
  }

  return(vw_cov_temp)
}
