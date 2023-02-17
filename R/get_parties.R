#' Get personnel
#' @details This function will grab responsibleParty-type nodes from these nodes: creator, associatedParty, contact, publisher, metadataProvider, and project/personnel, and output a table of personnel information.
#' @param corpus (list) List of EML documents, output from import_corpus
#'
#' @return (data.frame) Table of personnel information: name, address, organization, role, position, email etc
#' @export
#'
#' @examples
get_parties <- function(corpus) {
  vw <- list()

  # loop through each EML doc in corpus
  for (i in seq_along(corpus)) {
    pk <- parse_packageId(names(corpus)[[i]])
    scope <- pk[["scope"]]
    id <- pk[["datasetid"]]
    rev <- pk[["rev"]]

    groups <-
      c(purrr::compact(corpus[[i]][["dataset"]][c("creator",
                                                "associatedParty",
                                                "contact",
                                                "publisher",
                                                "metadataProvider")]),
        purrr::compact(corpus[[i]][["dataset"]][["project"]]["personnel"]))
    # party_list <- c(party_list, parties)
groupdf <- list()
    for (j in seq_along(groups)) {
      group <- handle_one(groups[[j]])

      plist <- lapply(seq_along(group), function(x) {
        person <- group[[x]]
        # get authorship order if creator
        if (names(groups)[[j]] == "creator")
          order <- paste0(j, x)
        else
          order <- NA

        type <- names(groups)[[j]]
        if (type == "personnel") type <- "project personnel"
        # get role if not associatedparty
        if (!type %in% c("personnel", "associatedParty")) role <- NA
        else role <- null2na(person[["role"]])

        pdf <- parse_party(person)
        return(cbind(
          data.frame(
            id = id,
            scope = scope,
            rev = rev,
            order = order,
            type = type,
            role = role
          ),
          pdf
        ))
      })

      groupdf[[j]] <- data.table::rbindlist(plist, fill = TRUE)
    }
vw[[i]] <- data.table::rbindlist(groupdf, fill = TRUE)
  }
  return(data.table::rbindlist(vw, fill = TRUE))
}


#' parse responsible party
#'
#' @param x (list) a responsible party node
#'
#' @return (data.frame) parsed node
#'
#' @examples
parse_party <- function(x) {
  data.frame(
    # salutation = null2na(handle_multiple((x[["individualName"]][["salutation"]])),
    firstname = I(null2na(handle_multiple(x[["individualName"]][["givenName"]]))),
    surname = null2na(x[["individualName"]][["surName"]]),
    organization = null2na(handle_multiple(x[["organizationName"]])),
    position = null2na(handle_multiple(x[["positionName"]])),
    address = null2na(paste(x[["address"]][["deliveryPoint"]], collapse = ", ")),
    city = null2na(x[["address"]][["city"]]),
    state = null2na(x[["address"]][["administrativeArea"]]),
    country = null2na(x[["address"]][["country"]]),
    zip = null2na(x[["address"]][["postalCode"]]),
    phone = null2na(handle_multiple(x[["phone"]])),
    email = I(null2na(handle_multiple(x[["electronicMailAddress"]]))),
    online_url = I(null2na(handle_multiple(x[["onlineUrl"]]))),
    stringsAsFactors = F
  )
}
