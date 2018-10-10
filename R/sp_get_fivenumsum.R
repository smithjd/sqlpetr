#' Calcualte a 5 number summary (for all types of variables)
#'
#' @param var The variable to be summarized
#' @param character_truncate_length the length of output character summaries (for )
#'
#' @return The min, max, median, and 25th and 75th percentiles
#' @export
#' @importFrom tibble as_tibble
#' @importFrom tibble tibble
#'
#' @examples summary_vector <- sp_get_fivenumsum(mtcars$mpg)
sp_get_fivenumsum <- function(var, character_truncate_length = 60){
  # emulate fivenum function for characters, numerics and POSIXct
  # if the values of a variable are all missing, this function crashes
  num_rows <- length(var)
  # handle SQL "missing value" for dates...
  # var <- ifelse(is.character(var) &
  #               (var == "0000-00-00 00:00:00" | var == "0000-00-00"), "", var)
  # var <- parse_guess(var)
  non_blanks <- var[!is.na(var)]
  non_missing_n <- length(non_blanks)
  if (non_missing_n == 0) {
    summary <- tibble(num_rows = num_rows, num_blank = num_rows, num_unique = 0,
                      min = "", q_25 = "", q_50 = "", q_75 = "", max = "")
    return(summary)
  } else if (non_missing_n == 1) {
    summary <- tibble(num_rows = num_rows, num_blank = num_rows, num_unique = 1,
                      min = "", q_25 = "", q_50 = as.character(non_blanks[1]),
                      q_75 = "", max = "")
    # summary$q_50 = as.character(non_blanks[1])
    return(summary)
  } else if (non_missing_n == 2) {
    ordered <- non_blanks[order(non_blanks)]
    summary <- tibble(num_rows = num_rows, num_blank = sum(is.na(var)),
                      num_unique = length(unique(non_blanks)),
                      min = as.character(ordered[1]),
                      q_25 = as.character(ordered[1]), q_50 = "",
                      q_75 = as.character(ordered[2]),
                      max = as.character(ordered[2]))
    return(summary)
  } else if (non_missing_n == 3) {
    ordered <- non_blanks[order(non_blanks)]
    summary <- tibble(num_rows = num_rows, num_blank = sum(is.na(var)),
                      num_unique = length(unique(non_blanks)),
                      min = as.character(ordered[1]),
                      q_25 = as.character(ordered[1]),
                      q_50 = as.character(ordered[2]),
                      q_75 = as.character(ordered[3]),
                      max = as.character(ordered[3]))
    return(summary)
  }
    else {
    # num_blank <- ifelse(is.Date(var),
    #                     sum(is.na(var)),
    #                     sum(var == ""))
    num_blank <- sum(is.na(var))
    num_unique <- length(unique(non_blanks))
    med_pos <- round((max(1,non_missing_n/2)),0)
    qrt_pos <- round((max(1,non_missing_n/4)),0)
    ordered <- non_blanks[order(non_blanks)]
    min <- ordered[1]
    q_25 <- ordered[(med_pos - qrt_pos)]
    q_50 <- ordered[med_pos]
    q_75 <- ordered[(med_pos + qrt_pos)]
    max <-  ordered[non_missing_n]
    summary <-
      tibble(num_rows, num_blank, num_unique,
             min  = substr(as.character(min), 1, character_truncate_length),
             q_25 = substr(as.character(q_25), 1, character_truncate_length),
             q_50 = substr(as.character(q_50), 1, character_truncate_length),
             q_75 = substr(as.character(q_75), 1, character_truncate_length),
             max  = substr(as.character(max), 1, character_truncate_length))
    return(summary)
  }
}
