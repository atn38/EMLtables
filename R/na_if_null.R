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

na_if_null <- function(x) {
  if (is.null(x)) return(NA)
  # account for when the element is present but empty or there are orphan closing tags
  else if (is.list(x) & length(x) == 0) return(NA)
  else if (is.character(x) && length(x) == 1 && trimws(x) == "") return(NA)
  else return(x)
}

