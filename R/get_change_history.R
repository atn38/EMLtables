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

get_changehistory <- function(corpus) {
  vw_change <- data.frame()

  for (i in seq_along(corpus)) {
    pk <- get_pk(names(corpus)[[i]])
    scope <- pk[["scope"]]
    id <- pk[["id"]]
    rev <- pk[["rev"]]

    changes <-
      handle_one(corpus[[i]][["dataset"]][["maintenance"]][["changeHistory"]])
    for (j in seq_along(changes)) {
      change <- changes[[j]]

      changedf <- data.frame(
        stringsAsFactors = F,
        scope = scope,
        id = id,
        rev = rev,
        change_scope = na_if_null(change[["changeScope"]]),
        date = na_if_null(change[["changeDate"]]),
        old_value = na_if_null(change[["oldValue"]]),
        new_value = na_if_null(change[["newValue"]]),
        note = na_if_null(change[["comment"]])
      )
      vw_change <- rbind(vw_change, changedf)
    }

  }
  return(vw_change)
}
