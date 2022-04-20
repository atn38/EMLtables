#' Download EML metadata from all data packages in an Environmental Data Initiative (EDI) scope.
#' @description This function fetchs newest IDs and revision numbers from a given EDI scope, then download EML metadata files to a specified directory. Newest revision from each package only. Files will be named after the full packageId as found in the metadata, e.g. "knb-lter-ble.1.7.xml".
#'
#' @param scope (character) EDI scope, e.g. "knb-lter-ble"
#' @param path (character) Path to existing directory to download EML files into
#' @param EDI_env (character) EDI server to query. Defaults to "production". Options are "production", "staging", or "development".
#'
#' @return Nothing in R, just download files.
#' @importFrom EDIutils list_data_package_identifiers list_data_package_revisions read_metadata
#' @export
#'
#' @examples
download_corpus <- function(scope, path, EDI_env = "production") {
  stopifnot(is.character(scope), dir.exists(path))
  message("Querying EDI for latest data identifiers...")
  # find the newest revision
  n <- EDIutils::list_data_package_identifiers(scope = scope,
                                                 env = EDI_env)
  # get the full packageIds
  full_ids <- sapply(n, function(x) {
    rev <- EDIutils::list_data_package_revisions(scope = scope,
                                                 identifier = x,
                                                 filter = "newest",
                                                 env = EDI_env)
    return(paste(scope, x, rev, sep = "."))
  })

  message("Starting download:")

   invisible(sapply(full_ids, function(x) {
    xml <- EDIutils::read_metadata(packageId = x,
                                 env = EDI_env)
    xml2::write_xml(x = xml, file = file.path(path, paste0(x, ".xml")))
    message(paste0("Writing file ", x, ".xml to path."))
  }))
   message("Done.")
}
