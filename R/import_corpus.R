#' Import a corpus of EML documents from a folder of .xml files.
#'
#' @param revision_pk (boolean) Defaults to FALSE. TRUE/FALSE whether you want to log more than one revision of the same data package in a relational database downstream, or in other words, would revision be a part of the primary key in your system later? For example, "knb-lter-mcr.1" is a unique package, and "knb-lter-mcr.1.1" is a unique revision of the former). This setting does not change any output from pkEML. If TRUE, pkEML only warns the user at import if the packageIds in your corpus contain revisions from the same data package and advises removal before proceeding. If FALSE, pkEML warns the user at import if the packageIds including revision in the corpus are not all unique and advises removal before proceeding.
#' @param path (character) Path to directory containing EML documents in .xml file format. Each document in the directory should have a unique packageId (e.g. "knb-lter-mcr.1.1" should only occur once). If there are duplicates, the output tables will have duplicated values in the identifying columns (scope, id, revision), which will result in error should you try and import the tables into a relational database system and assign primary keys.
#'
#' @return List of EML documents represented in the EMLD (JSON-LD) format. Each child in the list is named according to the package ID listed in EML, e.g. "knb-lter-mcr.1.1".
#' @importFrom EML read_eml eml_get
#' @export

import_corpus <- function(path, revision_pk = F) {
  stopifnot(dir.exists(path))
  corpus_emld <-
    lapply(list.files(path, pattern = ".xml", full.names = T),
           EML::read_eml)
  ids <-
    unlist(sapply(corpus_emld, EML::eml_get, element = "packageId")[c(TRUE, FALSE)])
  names(corpus_emld) <- ids
  no_revs <- sub('.[^.]*$', '', ids) # extract just the scope and ID

  # check for duplicate packageIDs
  if (revision_pk & any(duplicated(ids))) {
    warning(
      paste0(
        "Duplicate packageId(s) found, with accounting for revisions (since revision_pk is TRUE). Please remove the duplicate files from the directory then re-rerun this function, so that all the documents in the corpus have unique packageIds (e.g. \"knb-lter-mcr.1.1\" should only occur once). If you proceed, the output tables will have duplicated values in the identifying columns (scope, id, revision), which will result in error should you try and import the tables into a relational database system and assign primary keys. The duplicate(s) are: ",
        which(duplicated(ids))
      )
    )
  } else if (!revision_pk & any(duplicated(no_revs))) {
    warning(
      paste0(
        "Duplicate packageId(s) found, without accounting for revisions (since revision_pk is FALSE). Please remove the duplicate files from the directory then re-rerun this function, so that all the documents in the corpus have unique packageIds (e.g. \"knb-lter-mcr.1\" should only occur once). If you proceed, the output tables will have duplicated values in the identifying columns (scope, id), which will result in error should you try and import the tables into a relational database system and assign primary keys. This warning does not change any outputs from pkEML. The duplicate(s) are: ",
        which(duplicated(no_revs))
      )
    )
  }


  return(corpus_emld)
}
