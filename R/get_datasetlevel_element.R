#' Title
#'
#' @param corpus
#'
#' @return
#' @export
#'
#' @examples
get_datasetlevel_element <-
  function(corpus, element_names, parse_function) {
    e <- if (length(element_names) == 1) element_names else element_names[-1]
    message(paste("Getting", e, "..."))
    vw <- list()
    for (i in seq_along(corpus)) {
      pk <- parse_packageId(names(corpus)[[i]])
      scope <- pk[["scope"]]
      id <- pk[["id"]]
      rev <- pk[["rev"]]

      ddf <- data.frame()
      if (recursive_check(corpus[[i]][["dataset"]], element_names = element_names)) {
        d <- handle_one(corpus[[i]][["dataset"]][[element_names]])
        ddf <-
          data.table::rbindlist(lapply(seq_along(d), function(x)
            parse_function(d[[x]])), fill = TRUE)
        n <- ncol(ddf)
        cols <- c((n+1):(n+3), 1:n)
        ddf$scope <- scope
        ddf$id <- id
        ddf$rev <- rev
        ddf <- subset(ddf, select = cols)
      }
      vw[[i]] <- ddf
    }
    out <- data.table::rbindlist(vw)
    msgout(out)
    return(out)
  }
