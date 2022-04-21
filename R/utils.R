#' handles instances where there are multiple in a list and collapses them int a string
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


#' Parse packageId
#' @description Take the packageId field in EML and break it down into scope, id, and revision number. If packageId does not conform to the scope, id, revision number pattern, the function will just return the whole ID in the "id" field and NAs in the "scope" and "rev" fields.
#'
#' @param full_id (character) Package ID in EML style, e.g. "knb-lter-mcr.1.1"
#' @return List of three named items: "scope", "id", "rev".
#' @importFrom stringr str_extract

parse_packageId <- function(full_id) {
  stopifnot(is.character(full_id), length(full_id) == 1)
  if(!grepl("[^A-Za-z0-9 . -]", full_id) && # check that string only has A-Z, a-z, numeric, dashes, and periods
     nchar(gsub("[^.]", "", full_id)) == 2  && # check that string has exactly two periods
     !startsWith(full_id, ".") && # doesnt start with a period
     !endsWith(full_id, ".") # doesnt end with a period
     ) {
    x <- list(
      scope = sub("\\..*$", "", full_id), # string before first period
      id = stringr::str_extract(full_id, "(?<=\\.)(.+)(?=\\.)"), # number between the two periods
      rev = sub(".*\\.", "", full_id) # number after second period
    )
  } else x <- list(scope = NA,
                   id = full_id,
                   rev = NA)

  return(x)
}

#' Title
#'
#' @param x (list or character) text node
#'
#' @return
#'
#' @examples
parse_text <- function(x) {
  a <- type <- NA
  if (is.character(x)) {
    a <- x
    type <- "plaintext"
  }
  if (is.list(x)) {
    if ("markdown" %in% names(x)) {
      a <- as.character(x[["markdown"]])
      type <- "markdown"
    } else {
      a <- a[!names(a) %in% c("@context", "@type")]
      a <- as.character(emld::as_xml(x))
      a <- gsub("<?xml version=\"1.0\" encoding=\"UTF-8\"?>", "", a)
      a <- stringr::str_remove(a, ".*xsd\">")
      a <- stringr::str_remove(a, "</eml:eml>")
      substr(a, 1, 40) <- ""
      type <- "docbook"
    }
  } else {
    a <- as.character(x)
  }
  return(list(text = a, type = type))
}
#' Title
#'
#' @param x (list) node to check
#' @param element_names (character) Name or vector of descending names to check
#'
#' @return
#'
#' @examples
recursive_check <- function(x, element_names) {
  check <- TRUE
  for (i in seq_along(element_names)) {
    if (i == 1) {
      if (!element_names[[1]] %in% names(x))
        check <- FALSE
    }
    else {
      if (!element_names[[i]] %in% names(x[[element_names[1:(i - 1)]]]))
        check <- FALSE
    }
  }
  return(check)
}


#' Remove context
#'
#' @param x
#'
#' @return
#' @examples
remove_context <- function(x){


}
