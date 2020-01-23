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
  short <- sapply(corpus, function(x) na_if_null(x[["dataset"]][["shortName"]]))

  pk <- lapply(names(corpus), get_pk)
  scope <- sapply(pk, `[[`, "scope")
  id <- sapply(pk, `[[`, "id")
  rev <- sapply(pk, `[[`, "rev")

  # abstracts
  abstract <- lapply(corpus, function(x) na_if_null(x[["dataset"]][["abstract"]]))

  # pubdate
  pub <- sapply(corpus, function(x) na_if_null(x[["dataset"]][["pubDate"]]))

  # maintenance
  main_desc <- lapply(corpus, function(x) na_if_null(x[["dataset"]][["maintenance"]][["description"]]))
  freq <- sapply(corpus, function(x) na_if_null(x[["dataset"]][["maintenance"]][["maintenanceUpdateFrequency"]]))

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
