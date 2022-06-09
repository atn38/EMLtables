#' Get custom dataset-level metadata
#'
#' @details this function will loop through all datasets in the supplied corpus and output a table of parsed metadata from the specified node according to the supplied parse function. Note that dataset-level here is meant different from dataset metadata that get_dataset() gets. Dataset-level refers to nodes that have child nodes in themselves, such as maintenance, but appear under dataset in a EML document.
#'
#' @param corpus (list) List of EML documents, output from import_corpus
#' @param element_names (character) A string specifying the dataset-level. If the desired node is not an immediate child node of dataset, than supply a character vector to specify the xpath leading to the desired node. For example, to get geographicCoverage, say c("coverage", "geographicCoverage").
#' @param parse_function (function) A parse function, taking a EML node and outputting a data.frame
#'
#' @return (data.frame) A table containing parsed metadata from the specified node according to the supplied parse function.
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
      id <- pk[["datasetid"]]
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
        ddf$datasetid <- id
        ddf$rev <- rev
        ddf <- subset(ddf, select = cols)
      }
      vw[[i]] <- ddf
    }
    out <- data.table::rbindlist(vw)
    msgout(out)
    return(out)
  }
