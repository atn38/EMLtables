#'
#'
#'
#'
#'
#'
#'


get_pk <- function(full_id) {
  stopifnot(is.character(full_id), length(full_id) == 1)
  return(list(
    scope = sub("\\..*$", "", full_id), # string before first period
    id = str_extract(full_id, "(?<=\\.)(.+)(?=\\.)"), # number between the two periods
    rev = sub(".*\\.", "", full_id) # number after second period
  ))
}
