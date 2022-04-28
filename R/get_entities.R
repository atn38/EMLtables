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
    # attgroupdf <- list()
    # loop through each entity group
    for (j in seq_along(ent_groups)) {
      ents <- handle_one(ent_groups[[j]])

      # loop through each entity in each entity group
      ent_list <- lapply(seq_along(ents), function(x) {

        info <- data.frame(scope = scope,
        id = id,
        rev = rev,
        entity = paste0(j, x),
        entitytype = paste0(names(ent_groups)[[j]]),
        stringsAsFactors = F)

        entdf2 <- parse_entity(ents[[x]])

        # # get attributes
        # atts <- parse_attributeList(x = ents[[x]], eml = corpus[[i]])
        # n <- nrow(atts)
        # attdf <- cbind(info[rep(seq_len(nrow(info)), each = n), ], atts)
        return(cbind(info, entdf2))
      })
      entgroupdf[[j]] <- data.table::rbindlist(ent_list, fill = TRUE)
      # attgroupdf[[j]] <- data.table::rbindlist(ent_list[[att]], fill = TRUE)
    }
    vw_entities[[i]] <- data.table::rbindlist(entgroupdf, fill = TRUE)
    # vw_atts[[i]] <- data.table::rbindlist(attgroupdf, fill = TRUE)
  }

  return(data.table::rbindlist(vw_entities, fill = TRUE))
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
    entitydescription = trimws(I(null2na(
      ent$entityDescription
    ))),
    nrow = null2na(ent$numberOfRecords),
    filename = null2na(ent$physical$objectName),
    filesize = null2na(ent$physical$size$size),
    filesizeunit = null2na(ent$physical$size$unit),
    checksum = null2na(ent$physical$authentication$authentication),
    stringsAsFactors = F
  )
}
