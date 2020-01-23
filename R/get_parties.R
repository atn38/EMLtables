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


get_parties <- function(corpus) {
  party_list <- list()
  vw_parties <- data.frame()

  # loop through each EML doc in corpus
  for (i in seq_along(corpus)) {
    pk <- get_pk(names(corpus)[[i]])
    scope <- pk[["scope"]]
    id <- pk[["id"]]
    rev <- pk[["rev"]]

    parties <-
      purrr::compact(corpus[[i]][["dataset"]][c("creator",
                                                "associatedParty",
                                                "contact",
                                                "publisher",
                                                "metadataProvider")])

    # party_list <- c(party_list, parties)

    for (j in seq_along(parties)) {
      party <- parties[[j]]
      if (!is.null(names(party)))
        party <- list(party)

      for (k in seq_along(party)) {
        entity <- party[[k]]

        # get authorship order if creator
        if (names(parties)[[j]] == "creator")
          order <- paste0(j, k)
        else
          order <- NA

        # get role if not associatedparty
        if (names(parties)[[j]] != "associatedParty")
          role <- names(parties)[[j]]
        else if (names(parties)[[j]] == "associatedParty")
          role <- na_if_null(entity[["role"]])

        first <-
          na_if_null(handle_multiple(entity[["individualName"]][["givenName"]]))
        sur <- na_if_null(entity[["individualName"]][["surName"]])
        org <- na_if_null(entity[["organizationName"]])

        address <-
          na_if_null(paste(entity[["address"]][["deliveryPoint"]], collapse = ", "))
        city <- na_if_null(entity[["address"]][["city"]])
        state <-
          na_if_null(entity[["address"]][["administrativeArea"]])
        country <- na_if_null(entity[["address"]][["country"]])
        zip <- na_if_null(entity[["address"]][["postalCode"]])
        phone <- na_if_null(handle_multiple(entity[["phone"]]))
        email <-
          na_if_null(handle_multiple(entity[["electronicMailAddress"]]))
        web <- na_if_null(handle_multiple(entity[["onlineUrl"]]))

        position <- na_if_null(entity[["positionName"]])

        partydf <- data.frame(
          scope = I(scope),
          id = id,
          rev = rev,
          order = order,
          role = I(role),
          firstname = I(first),
          surname = sur,
          organization = org,
          position = position,
          address1 = address,
          city = city,
          state = state,
          country = country,
          zip = zip,
          phone = phone,
          email = I(email),
          online_url = I(web),
          stringsAsFactors = F
        )

        vw_parties <- rbind(vw_parties, partydf)
      }


    }
  }
  return(vw_parties)
}
