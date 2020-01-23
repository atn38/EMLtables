#'
#'
#'
#'
#'
#'
#'
#'
#'

get_entities <- function(corpus) {
  ents <- list()
  vw_entities <- data.frame()

  # loop through each EML doc in corpus
  for (i in seq_along(corpus)) {

    pk <- get_pk(names(corpus)[[i]])
    scope <- pk[["scope"]]
    id <- pk[["id"]]
    rev <- pk[["rev"]]

    entities <-
      purrr::compact(corpus[[i]][["dataset"]][c("dataTable", "otherEntity")])

    # loop through each entity

    for (j in seq_along(entities)) {
      ent <- entities[[j]]
      if (!all(is.null(names(ent))))
        ent <- list(ent)
      if (names(entities)[[j]] == "dataTable") {
        for (k in seq_along(ent)) {

          dt <- ent[[k]]

          entdf <- data.frame(
            scope = scope,
            id = id,
            rev = rev,
            entityposition = paste0(j, k),
            entitytype = "dataTable",
            entityname = dt[["entityName"]],
            entitydescription = I(dt[["entityDescription"]]),
            stringsAsFactors = F
          )
          vw_entities <- rbind(vw_entities, entdf)
        }
      } else if (names(entities)[[j]] == "otherEntity") {
        for (k in seq_along(ent)) {

          oe <- ent[[k]]

          entdf <- data.frame(
            scope = scope,
            id = id,
            rev = rev,
            entityposition = paste0(j, k),
            entitytype = "otherEntity",
            entityname = oe[["entityName"]],
            entitydescription = I(oe[["entityDescription"]]),
            stringsAsFactors = F
          )
          vw_entities <- rbind(vw_entities, entdf)
        }
      }


      # if (!all(is.null(names(dt)))) dt <- list(dt)


      # ents <- c(ents, ent)
    }
  }

  return(vw_entities)
}
