#'
#'
#'
#'
#'
#'
#' @import emld
#' @import EML
#' @import stringr


# assumptions
# one scope
# all .xml files are EML docs

get_dataset <- function(corpus){

  title <- sapply(corpus, function(x) x[["dataset"]][["title"]])
  short <- sapply(corpus, function(x) x[["dataset"]][["shortName"]])
  # get string before first period -- scope
  scope <- sub("\\..*$", "", names(corpus))
 # return(scope)

  # get string between the two periods -- datasetid
  id <- str_extract(names(corpus), "(?<=\\.)(.+)(?=\\.)")

  # get string after last period -- revision

  rev <- sub(".*\\.", "", names(corpus))
  # abstracts
  abstract <- lapply(corpus, function(x) x[["dataset"]][["abstract"]])

  # pubdate
  pub <- sapply(corpus, function(x) x[["dataset"]][["pubDate"]])

  # maintenance
  main_desc <- lapply(corpus, function(x) x[["dataset"]][["maintenance"]][["description"]])
  freq <- sapply(corpus, function(x) x[["dataset"]][["maintenance"]][["maintenanceUpdateFrequency"]])
  # NULLS to NAs
  freq <- lapply(freq, function(x) ifelse(is.null(x), NA, x))

  vw_dataset <- data.frame(packageId = names(corpus),
                           scope = scope,
                           datasetid = id,
                           revision_number = rev,
                           title = title,
                           shortname = short,
                           abstract = I(abstract),
                           maintenanceupdatefrequency = I(freq),
                           maintenance_description = I(main_desc),
                           stringsAsFactors = F,
                           fix.empty.names = F, check.names = F)


  return(vw_dataset)
}
