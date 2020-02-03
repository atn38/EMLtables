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
#' only data table attributes for now

get_attributes <- function(corpus) {
  vw_att <- data.frame()

  for (i in seq_along(corpus)) {
    pk <- get_pk(names(corpus)[[i]])
    scope <- pk[["scope"]]
    id <- pk[["id"]]
    rev <- pk[["rev"]]

    dts <-
      handle_one(purrr::compact(corpus[[i]][["dataset"]][["dataTable"]]))

    for (j in seq_along(dts)) {
      dt <- dts[[j]]

      if (!is.null(dt[["attributeList"]])) {
        attdf <- EML::get_attributes(x = dt[["attributeList"]],
                                     eml = corpus[[i]])
        how_many <- nrow(attdf[["attributes"]])
        # print(how_many)
        attdf2 <- data.frame(
          stringsAsFactors = F,
          scope = rep(scope, how_many),
          id = rep(id, how_many),
          rev = rep(rev, how_many),
          entityposition = rep(j, how_many)
        )

        # print(str(attdf[["attributes"]]))

        attdf <- dplyr::bind_cols(attdf2,attdf[["attributes"]])

        vw_att <- dplyr::bind_rows(vw_att, attdf)
      }
    }

  }
  return(vw_att)
}
