






#' Title
#'
#' @param corpus
#'
#' @return
#' @export
#'
#' @examples
get_attributes <- function(corpus) {
  vw_att <- list()

  for (i in seq_along(corpus)) {
    eml <- corpus[[i]]
    pk <- parse_packageId(names(corpus)[[i]])
    scope <- pk[["scope"]]
    id <- pk[["id"]]
    rev <- pk[["rev"]]

    ent_groups <-
      purrr::compact(eml[["dataset"]][c("dataTable",
                                                "spatialVector",
                                                "spatialRaster",
                                                "otherEntity",
                                                "view")])
    # exit if no entities found
    if (is.null(ent_groups))
      return()
    groupdf <- list()
    for (j in seq_along(ent_groups)) {
      ents <- handle_one(ent_groups[[j]])

      att_list <- lapply(seq_along(ents), function(x) {
        ent <- ents[[x]]
        if ("attributeList" %in% names(ent)) {
          attdf <-
            parse_attributeList(x = ent[["attributeList"]])#,
          #eml = corpus[[i]]))
          n <-
            nrow(attdf)
          #print(paste(i, j, how_many))
          #print(attdf$attributes)
          info <- data.frame(
            stringsAsFactors = F,
            scope = rep(scope, n),
            datasetid = rep(id, n),
            rev = rep(rev, n),
            entity = rep(paste0(j, x), n),
            entitytype = paste0(names(ent_groups)[[j]])
          )
          return(cbind(info, attdf))
        }
      })
      groupdf[[j]] <- data.table::rbindlist(att_list, fill = TRUE)
    }
    vw_att[[i]] <- data.table::rbindlist(groupdf, fill = TRUE)
  }
  return(data.table::rbindlist(vw_att, fill = TRUE))
}





#' Title
#'
#' @param eml
#' @param x (list) attributeList EML node
#'
#' @return
#'
#' @examples
parse_attributeList <- function(x, eml = NULL) {
  attributeList <- x
  ## check to make sure input appears to be an attributeList
  if (!("attribute" %in% names(attributeList)) &
      is.null(attributeList$references)) {
    stop(call. = FALSE,
         "Input does not appear to be an attributeList.")
  }
  ## if the attributeList is referenced, get reference
  if (!is.null(attributeList$references)) {
    if (is.null(eml)) {
      warning(
        "The attributeList entered is referenced somewhere else in the eml. ",
        "No eml was entered to find the attributes. ",
        "Please enter the eml to get better results."
      )
      eml <- x
    }

    all_attributeLists <- eml_get(eml, "attributeList")

    for (attList in all_attributeLists) {
      if (attList$id == attributeList$references) {
        attributeList <- attList
        break
      }
    }
  }
  attributes <- lapply(handle_one(attributeList$attribute), parse_attribute)
  attributes <- data.table::rbindlist(attributes, fill = T)
  ## remove non_fields in attributes
  non_fields <- c("enforced",
                  "exclusive",
                  "order",
                  "references",
                  "scope",
                  "system",
                  "typeSystem",
                  "missingValueCode",
                  "missingValueCodeExplanation",
                  "propertyLabel",
                  "propertyURI",
                  "valueLabel",
                  "valueURI")
  attributes <-
    subset(attributes, select = !(names(attributes) %in% non_fields))
  return(attributes)
}




#' Title
#'
#' @param x (list) attribute EML node
#'
#' @return
#'
#' @examples
parse_attribute <- function(x) {
  ## get full attribute list
  att <- unlist(x, recursive = TRUE, use.names = TRUE)
  measurementScale <- names(x$measurementScale)
  domain <- names(x$measurementScale[[measurementScale]])

  if (length(domain) == 1) {
    ## domain == "nonNumericDomain"
    domain <-
      names(x$measurementScale[[measurementScale]][[domain]])
  }
  domain <- domain[grepl("Domain", domain)]

  if (measurementScale == "dateTime" & is.null(domain)) {
    domain <- "dateTimeDomain"
  }

  att <-
    c(att, measurementScale = measurementScale, domain = domain)

  ## separate factors
  att <- att[!grepl("enumeratedDomain", names(att))]

  ## separate methods
  att <- att[!grepl("methods", names(att))]

  ## Alter names to be consistent with other tools
  names(att) <- gsub("standardUnit|customUnit",
                      "unit",
                      names(att))
  names(att) <- gsub(".+\\.+",
                      "",
                      names(att))
  att <- as.data.frame(t(att), stringsAsFactors = FALSE)
  return(att)
}
