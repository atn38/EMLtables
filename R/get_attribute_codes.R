#' Title
#'
#' @param corpus
#'
#' @return
#' @export
#'
#' @examples
get_attribute_codes <- function(corpus) {
  message("Getting attribute enumeration and missing codes...")
  vw_codes <- list()

  for (i in seq_along(corpus)) {
    pk <- parse_packageId(names(corpus)[[i]])
    scope <- pk[["scope"]]
    datasetid <- pk[["id"]]
    rev <- pk[["rev"]]

    ent_groups <-
      purrr::compact(corpus[[i]][["dataset"]][c("dataTable",
                                                "otherEntity",
                                                "spatialRaster",
                                                "spatialVector")])
    # exit if no entities found
    if (is.null(ent_groups))
      return()
    groupdf <- list()
    for (j in seq_along(ent_groups)) {
      ents <- handle_one(ent_groups[[j]])
      c_list <- lapply(seq_along(ents), function(x) {
        ent <- ents[[x]]
        if ("attributeList" %in% names(ent)) {
          atts <- handle_one(ent[["attributeList"]][["attribute"]])
          codedf <-
            data.table::rbindlist(lapply(seq_along(atts), function(x) {
              c <- parse_attribute_code(atts[[x]])
              if (!is.null(c) && nrow(c) > 0)
                c$attribute <- x
              return(c)
            }))
            }), fill = TRUE)
          if (!is.null(codedf) & nrow(codedf) > 0) {
            n <- nrow(codedf)
            info <-
              data.frame(
                stringsAsFactors = F,
                scope = rep(scope, n),
                datasetid = rep(datasetid, n),
                rev = rep(rev, n),
                entity = rep(paste0(j, x), n),
                entitytype = paste0(names(ent_groups)[[j]])
              )
            return(cbind(info, codedf))
          }
        }
      })
      groupdf[[j]] <- data.table::rbindlist(c_list, fill = TRUE)
    }
    vw_codes[[i]] <- data.table::rbindlist(groupdf, fill = TRUE)
  }
  out <- data.table::rbindlist(vw_codes, fill = TRUE)[, c(1:5, 10, 8:9, 6:7)]
  msgout(out)
  return(out) # reorder cols
}

#' Title
#'
#' @param x attribute node
#'
#' @return
#'
#' @examples
parse_attribute_code <- function(x) {
  # you can just use EML::EML_get instead, but the following ten lines or so is faster by about 300 times
  # factors <- data.frame(stringsAsFactors = F)
  measurementScale <- names(x$measurementScale)
  domain <- names(x$measurementScale[[measurementScale]])
  # this seems to be the same thing as checking for domain == "nonNumericDomain, since if dateTimeDomain there will be a dateTimePrecision, and if numericDomain there will be a unit
  if (length(domain) == 1) {
    y <- names(x$measurementScale[[measurementScale]][[domain]])
    domain_deepest <- y[grepl("Domain", y)]
  } else
    domain_deepest <- domain[grepl("Domain", domain)]
  if (measurementScale == "dateTime" & (is.null(domain_deepest) || length(domain_deepest) == 0)){
    domain_deepest <- "dateTimeDomain"
  }
  codes <- handle_one(x$missingValueCode)

  if (domain_deepest != "enumeratedDomain" &&
      is.null(codes))
    return()
  factors <- data.frame()
  if (domain_deepest == "enumeratedDomain") {
    if (domain == domain_deepest)
      factors <-
        x$measurementScale[[measurementScale]][["enumeratedDomain"]]
    else
      factors <-
        x$measurementScale[[measurementScale]][[domain]][["enumeratedDomain"]]

    # print(factors)
    ## linearize factors
    factors <- lapply(factors$codeDefinition, function(x) {
    factors <- lapply(handle_one(factors$codeDefinition), function(x) {
      as.data.frame(x, stringsAsFactors = FALSE)
    })
    factors <- do.call(rbind, factors)

    if (!is.null(factors) && nrow(factors) > 0) {
      factors$attributeName <- x$attributeName
      factors$codetype <- "factor"
      names(factors)[1:2] <- c("code", "definition")
    }
  }

  if (!is.null(codes)) {
    codes <- lapply(codes, as.data.frame, stringAsFactors = FALSE)
    codes <- data.table::rbindlist(codes)
    codes$attributeName <- x$attributeName
    codes$codetype <- "missingcode"
    names(codes)[1:2] <- c("code", "definition")
  }
  codes <- rbind(factors, codes)
  return(codes)
}
