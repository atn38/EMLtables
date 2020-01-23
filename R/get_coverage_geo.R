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
#'

get_coverage_geo <- function(corpus){
  vw_geo_cov <- data.frame()

  for (i in seq_along(corpus)) {
    pk <- get_pk(names(corpus)[[i]])
    scope <- pk[["scope"]]
    id <- pk[["id"]]
    rev <- pk[["rev"]]

    covs <- corpus[[i]][["dataset"]][["coverage"]][["geographicCoverage"]]
    if (!is.null(names(covs))) covs <- list(covs)
    for (j in seq_along(covs)){
      cov <- covs[[j]]

      covdf <- data.frame(
        stringsAsFactors = F,
        scope = scope,
        id = id,
        rev = rev,
        desc = na_if_null(cov[["geographicDescription"]]),
        west = na_if_null(cov[["boundingCoordinates"]][["westBoundingCoordinate"]]),
        east = na_if_null(cov[["boundingCoordinates"]][["eastBoundingCoordinate"]]),
        north = na_if_null(cov[["boundingCoordinates"]][["northBoundingCoordinate"]]),
        south = na_if_null(cov[["boundingCoordinates"]][["southBoundingCoordinate"]]),
        altitude_min = na_if_null(cov[["boundingCoordinates"]][["boundingAltitudes"]][["altitudeMinimum"]]),
        altitude_max = na_if_null(cov[["boundingCoordinates"]][["boundingAltitudes"]][["altitudeMaximum"]]),
        altitude_unit = na_if_null(cov[["boundingCoordinates"]][["boundingAltitudes"]][["altitudeUnits"]])
      )

      vw_geo_cov <- rbind(vw_geo_cov, covdf)
    }


  }
return(vw_geo_cov)

}
