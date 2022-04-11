#' Title
#'
#' @param corpus
#' @param element_name
#' @param parse_function
#'
#' @return
#' @export
#'
#' @examples
get_multilevel_element <- function(corpus, element_names, parse_function) {
  stopifnot(is.list(corpus), is.function(parse_function), is.character(element_names))
  vw <- list()
  for (i in seq_along(corpus)) {
    eml <- corpus[[i]]
    pk <- parse_packageId(names(corpus)[[i]])
    scope <- pk[["scope"]]
    id <- pk[["id"]]
    rev <- pk[["rev"]]

    # dataset level
    ddf <- edf <- adf <- data.frame()
    if (recursive_check(eml[["dataset"]], element_names)) {
      da <- handle_one(eml[["dataset"]][[element_names]])
      ddf <-
        data.table::rbindlist(lapply(seq_along(da), function(x)
          parse_function(da[[x]])), fill = TRUE)
      n <- ncol(ddf)
      cols <- c((n+1):(n+7), 1:n)
      ddf$scope <- scope
      ddf$id <- id
      ddf$rev <- rev
      ddf$entity <- NA
      ddf$entitytype <- NA
      ddf$attribute <- NA
      ddf$attributename <- NA
      ddf <- subset(ddf, select = cols)
    }


    # entity level
    ent_groups <-
      purrr::compact(eml[["dataset"]][c("dataTable",
                                        "spatialVector",
                                        "spatialRaster",
                                        "otherEntity",
                                        "view")])
    groupdf <- list()
    if (!is.null(ent_groups)) {
      for (j in seq_along(ent_groups)) {
        ents <- handle_one(ent_groups[[j]])
        elist <- lapply(seq_along(ents), function(x) {
          edf <- data.frame()
          ent <- ents[[x]]
          if (recursive_check(ent, element_names)) {
            # entity level
            ea <- handle_one(ent[[element_names]])
            edf <-
              data.table::rbindlist(lapply(seq_along(ea), function(x)
                parse_function(ea[[x]])),
                fill = TRUE)
            n <- ncol(edf)
            cols <- c((n+1):(n+7), 1:n)
            edf$scope <- scope
            edf$id <- id
            edf$rev <- rev
            edf$entity <- paste0(j, x)
            edf$entitytype <- paste0(names(ent_groups)[[j]])
            edf$attribute <- NA
            edf$attributename <- NA
            edf <- subset(edf, select = cols)
          }

          a <- list()
          # attribute level
          if ("attributeList" %in% names(ent)) {
            atts <- handle_one(ent$attributeList$attribute)
            a <-
              data.table::rbindlist(lapply(seq_along(atts), function(y) {
                att <- atts[[y]]
                adf <- data.frame()
                if (recursive_check(att, element_names)) {
                  aa <- handle_one(att[[element_names]])
                  adf <-
                    data.table::rbindlist(lapply(seq_along(aa), function(x)
                      parse_function(aa[[x]])),
                      fill = TRUE)
                  n <- ncol(adf)
                  cols <- c((n+1):(n+7), 1:n)
                  adf$scope <- scope
                  adf$id <- id
                  adf$rev <- rev
                  adf$entity <- paste0(j, x)
                  adf$entitytype <- paste0(names(ent_groups)[[j]])
                  adf$attribute <- y
                  adf$attributename <- att$attributeName
                  adf <- subset(adf, select = cols)
                }
                return(adf)
              }), fill = TRUE)
          }

          return(rbind(edf, a))
        })
        groupdf[[j]] <- data.table::rbindlist(elist, fill = TRUE)
      }
    }
    vw[[i]] <-
      rbind(ddf, data.table::rbindlist(groupdf, fill = TRUE), fill = TRUE)
  }
  return(data.table::rbindlist(vw, fill = TRUE))
}
