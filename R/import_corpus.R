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

import_corpus <- function(dir){
  stopifnot(dir.exists(dir))

  corpus <- list.files(dir, pattern = ".xml", full.names = T)
  corpus_emld <- lapply(corpus, read_eml)
  ids <- unlist(sapply(corpus_emld, eml_get, element = "packageId")[c(TRUE, FALSE)])
  names(corpus_emld) <- ids
  return(corpus_emld)
  }
