#' Title
#' @param corpus
#' @return
#' @export
get_coverage_geo <- function(corpus){
  get_multilevel_element(corpus = corpus,
                         element_names = c("coverage", "geographicCoverage"),
                         parse_function = parse_geocov)
}

#' Title
#'
#' @param x
#'
#' @return
#'
#' @examples
parse_geocov <- function(x) {
  data.frame(
    stringsAsFactors = F,
    desc = null2na(x[["geographicDescription"]]),
    west = null2na(x[["boundingCoordinates"]][["westBoundingCoordinate"]]),
    east = null2na(x[["boundingCoordinates"]][["eastBoundingCoordinate"]]),
    north = null2na(x[["boundingCoordinates"]][["northBoundingCoordinate"]]),
    south = null2na(x[["boundingCoordinates"]][["southBoundingCoordinate"]]),
    altitude_min = null2na(x[["boundingCoordinates"]][["boundingAltitudes"]][["altitudeMinimum"]]),
    altitude_max = null2na(x[["boundingCoordinates"]][["boundingAltitudes"]][["altitudeMaximum"]]),
    altitude_unit = null2na(x[["boundingCoordinates"]][["boundingAltitudes"]][["altitudeUnits"]])
  )
}
