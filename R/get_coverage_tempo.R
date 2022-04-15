

#' Title
#'
#' @param corpus
#'
#' @return
#' @export
#'
#' @examples
get_coverage_tempo <- function(corpus) {
  get_multilevel_element(corpus = corpus,
                         element_names =  c("coverage", "temporalCoverage"),
                         parse_function = parse_tempocov)
}

#' Title
#'
#' @param x
#'
#' @return
#'
#' @examples
parse_tempocov <- function(x) {
  if ("singleDateTime" %in% names(x)) {
    dates <- handle_one(x[["singleDateTime"]])
    data.table::rbindlist(lapply(seq_along(dates), function(x) {
      data.frame(
        datetype = "single date",
        begin = null2na(dates[[x]][["calendarDate"]]),
        end = null2na(dates[[x]][["calendarDate"]]),
        alternativeTimeScaleName = null2na(dates[[x]][["alternativeTimeScale"]][["timeScaleName"]]),
        alternativeTimeScaleAgeEstimate = null2na(dates[[x]][["alternativeTimeScale"]][["timeScaleAgeEstimate"]])
      )
    }))
  } else if ("rangeOfDates" %in% names(x)) {
    data.frame(datetype = "range of dates",
               begin = null2na(x[["rangeOfDates"]][["beginDate"]][["calendarDate"]]),
               end = null2na(x[["rangeOfDates"]][["endDate"]][["calendarDate"]]),
    alternativeTimeScaleName = null2na(x[["rangeOfDates"]][["alternativeTimeScale"]][["timeScaleName"]]),
    alternativeTimeScaleAgeEstimate = null2na(x[["rangeOfDates"]][["alternativeTimeScale"]][["timeScaleAgeEstimate"]])
    )
  }
}
