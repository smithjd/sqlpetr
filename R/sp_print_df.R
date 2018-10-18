#' Print a data frame appropriate to output type
#'
#'
#'
#' @param df the data frame to be printed
#'
#' @return either kable (in PDF) or datatable (in HTML) output
#' @importFrom DT datatable
#' @importFrom knitr kable
#' @export
#'
#' @examples # sp_print_df(df)
sp_print_df <- function(df){
  if (knitr::is_latex_output()) {
    knitr::kable(df)
  } else {
    DT::datatable(df)
  }
  }
