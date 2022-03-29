#' handles instances where there are multiple in a list and collapses them
#' @param x
#' @param paste

handle_multiple <- function(x, paste = T) {
  if (paste) {
    if (is.list(x) && length(x) > 0) return(paste(sapply(x, paste, collapse = " "), collapse = " "))
    else return(x)
  } else return(x)
}


#'
#'
#'
#'

# write a thing to

handle_one <- function(x) {
  if (!is.null(names(x))) x <- list(x)
  return(x)
}



#' @param x

null2na <- function(x) {
  if (is.null(x)) return(NA)
  # account for when the element is present but empty or there are orphan closing tags
  else if (is.list(x) & length(x) == 0) return(NA)
  else if (is.character(x) && length(x) == 1 && trimws(x) == "") return(NA)
  else return(x)
}


#' Take the package ID and break it down into scope, id, and revision number.
#'
#' @param full_id (character) Package ID in EML style, e.g. "knb-lter-mcr.1.1"
#' @return List of three items: "scope", "id", "rev".
#' @importFrom stringr str_extract

parse_packageId <- function(full_id) {
  stopifnot(is.character(full_id), length(full_id) == 1)
  return(list(
    scope = sub("\\..*$", "", full_id), # string before first period
    id = stringr::str_extract(full_id, "(?<=\\.)(.+)(?=\\.)"), # number between the two periods
    rev = sub(".*\\.", "", full_id) # number after second period
  ))
}
