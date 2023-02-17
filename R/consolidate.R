#' Title
#'
#' @param tables
#' @param clean (logical) TRUE/FALSE on whether pkEML should attempt to clean the input tables before normalizing. Cleaning entails operations like trimming whitespace, case-standardization, removing non-alphanumeric symbols. pkEML will attempt to preserve the exact content extracted from EML where it matters, i.e. enumeration
#'
#' @return
#' @export
#'
#' @examples
normalize_tables <- function(tables, clean = FALSE) {
  stopifnot(is.data.frame(tables), c("scope", "datasetid", "rev") %in% colnames(tables))
  lookup <- data.frame()
  usage <- data.frame()

  id.vars <- c("scope", "datasetid", "rev", "entity", "attribute") # change as needed
  id.vars <- colnames(tables)[match(id.vars, colnames(tables))]
  data.vars <- setdiff(colnames(tables), c(id.vars, "entitytype", "attributeName"))
  lookup <- subset(tables, select = data.vars)
  lookup$asisID <- 1:nrow(lookup)
  if (cluster) {
    ref <- data.frame()
    # clean up and consolidate

    # Non altering
    lookup <- as.data.frame(lapply(lookup, stringr::str_squish))

    # Altering
    lookup2 <- as.data.frame(lapply(lookup, tolower))

    # things to do:
    # non altering: trimws, trimws from inside the string stringr::str_squish (but only on columns that do NOT appear in data, like definition)
    # possibly altering (i.e. use the altered version to group rows, but keep the presentation of one original): tolowercase, remove non alphanumeric symbols, cluster analysis?
    # other tools: ropenrefine


    # get new lookup tbl
    xrows <- which(duplicated(subset(lookup2, select = data.vars)))
    lookup2 <- lookup2[-xrows, ]
    lookup2$varid <- 1:nrow(lookup2)
    # ref$varid <- lookup$varid
    # lapply(seq_along(lookup), function(x) {
    #   col <- colnames(lookup)[[x]]
    #   ref[[col]] <- paste
    # })
    lookup2 <- readr::type_convert(lookup2)
    lookup <- lookup2
  }
  return(lookup)
}
