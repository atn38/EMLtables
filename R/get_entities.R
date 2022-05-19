#' Title
#'
#' @param corpus
#'
#' @return
#' @export
#'
#' @examples
get_entities <- function(corpus) {
  message("Getting data entities...")
  vw_entities <- list()
  vw_atts <- list()

  # loop through each EML doc in corpus
  for (i in seq_along(corpus)) {
    pk <- parse_packageId(names(corpus)[[i]])
    scope <- pk[["scope"]]
    id <- pk[["datasetid"]]
    rev <- pk[["rev"]]

    ent_groups <-
      purrr::compact(corpus[[i]][["dataset"]][c("dataTable",
                                                "spatialVector",
                                                "spatialRaster",
                                                "otherEntity",
                                                "view")])
    # exit if no entities found
    if (is.null(ent_groups))
      return()
    entgroupdf <- list()
    # loop through each entity group
    for (j in seq_along(ent_groups)) {
      ents <- handle_one(ent_groups[[j]])

      # loop through each entity in each entity group
      ent_list <- lapply(seq_along(ents), function(x) {
        info <- data.frame(
          scope = scope,
          datasetid = id,
          rev = rev,
          entity = paste0(j, x),
          entitytype = paste0(names(ent_groups)[[j]]),
          stringsAsFactors = F
        )

        entdf2 <- parse_entity(ents[[x]])
        return(cbind(info, entdf2))
      })
      entgroupdf[[j]] <-
        data.table::rbindlist(ent_list, fill = TRUE)
    }
    vw_entities[[i]] <-
      data.table::rbindlist(entgroupdf, fill = TRUE)
  }
  out <- data.table::rbindlist(vw_entities, fill = TRUE)
  msgout(out)
  return(out)
}

#' Title
#'
#' @param x
#'
#' @return
#'
#' @examples
parse_entity <- function(ent) {
  data.frame(
    entityname = ent$entityName,
    entitydescription = null2na(ent$entityDescription),
    nrow = null2na(ent$numberOfRecords),
    filename = null2na(ent$physical$objectName),
    filesize = null2na(ent$physical$size$size),
    filesizeunit = null2na(ent$physical$size$unit),
    checksum = null2na(ent$physical$authentication$authentication),
    stringsAsFactors = F
  )
}
