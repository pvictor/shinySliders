#' Print message for deprecated functions in Shiny
#'
#' To disable these messages, use \code{options(shiny.deprecation.messages=FALSE)}.
#'
#' @param new Name of replacement function.
#' @param msg Message to print. If used, this will override the default message.
#' @param old Name of deprecated function.
#' @param version The last version of Shiny before the item was deprecated.
#' @keywords internal
shinyDeprecated <- function(new=NULL, msg=NULL,
                            old=as.character(sys.call(sys.parent()))[1L],
                            version = NULL) {
  
  if (getOption("shiny.deprecation.messages") %OR% TRUE == FALSE)
    return(invisible())
  
  if (is.null(msg)) {
    msg <- paste(old, "is deprecated.")
    if (!is.null(new)) {
      msg <- paste(msg, "Please use", new, "instead.",
                   "To disable this message, run options(shiny.deprecation.messages=FALSE)")
    }
  }
  
  if (!is.null(version)) {
    msg <- paste0(msg, " (Last used in version ", version, ")")
  }
  
  # Similar to .Deprecated(), but print a message instead of warning
  message(msg)
}



# Given a vector or list, drop all the NULL items in it
dropNulls <- function(x) {
  x[!vapply(x, is.null, FUN.VALUE=logical(1))]
}



# Format a number without sci notation, and keep as many digits as possible (do
# we really need to go beyond 15 digits?)
formatNoSci <- function(x) {
  if (is.null(x)) return(NULL)
  format(x, scientific = FALSE, digits = 15)
}