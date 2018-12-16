#' Show (print) a data frame depending on appropriate output type
#'
#' @param df the data frame to be shown
#'
#' @return either kable (in PDF) or datatable (in HTML) output
#' @importFrom DT datatable
#' @importFrom knitr kable
#' @export
#'
#' @examples
#' \dontrun{sp_print_df(df)}
sp_print_df <- function(df){
  if (knitr::is_latex_output()) {
    knitr::kable(df)
  } else {
    DT::datatable(df)
  }
}
