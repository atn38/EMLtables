#'
#'
#'
#'
#'
#'


get_coverage_tempo <- function(corpus) {
  vw_cov_temp <- data.frame()

  for (i in seq_along(corpus)) {
    pk <- get_pk(names(corpus)[[i]])
    scope <- pk[["scope"]]
    id <- pk[["id"]]
    rev <- pk[["rev"]]

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
