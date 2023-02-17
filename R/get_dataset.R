#' Get dataset level metadata from EML corpus in table form
#' @param corpus (list) List of EML documents in EMLD format, each named according to the package ID listed in EML, e.g. "knb-lter-mcr.1.1". Output from import_corpus.
#' @return data.frame
#' @importFrom data.table rbindlist
#' @export

get_dataset <- function(corpus) {
  message("Getting datasets...")

  datasetList <- lapply(seq_along(corpus),
                        function(corpus, names, i) {
                          doc <- corpus[[i]]
                          abs <- parse_text(null2na(doc$dataset[["abstract"]]))
                          r <- parse_text(null2na(doc$dataset$intellectualRights))
                          pk <- parse_packageId(names[i])
                          dataset <- list(
                            packageId = names[i],
                            scope = pk[["scope"]],
                            datasetid = pk[["datasetid"]],
                            revision_number = pk[["rev"]],
                            title = doc$dataset$title,
                            shortname = null2na(doc$dataset$shortname),
                            abstract = abs[["text"]],
                            abstract_type = abs[["type"]],
                            maintenance_description = parse_text(null2na(doc$dataset$maintenance$description))[["text"]],
                            maintenance_update_frequency = I(null2na(doc$dataset$maintenance$maintenanceUpdateFrequency))
                          )
                          return(dataset)
                        },
                        corpus = corpus,
                        name = names(corpus))
  dataset <- data.table::rbindlist(datasetList)
  msgout(dataset)
  return(dataset)
}


