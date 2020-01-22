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

handle_multiple <- function(x, paste = T) {
  if (paste) {
  if (is.list(x) && length(x) > 0) return(paste(sapply(x, paste, collapse = " "), collapse = " "))
    else return(x)
  } else return(x)
}
