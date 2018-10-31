#' Show (print) a data frame depending on appropriate to output type
#'
#' @param df the data frame to be shown
#'
#' @return either kable (in PDF) or datatable (in HTML) output or View when executing chunks in an .Rmd file
#' @importFrom DT datatable
#' @importFrom knitr kable
#' @importFrom rlang enexprs
#' @importFrom utils View
#' @export
#'
#' @examples # sp_print_df(df)
sp_print_df <- function(df){
  df_name <- rlang::enexprs(df)
  if (knitr::is_latex_output()) {
    knitr::kable(df)
  }
  else if (knitr::is_html_output()) {
    DT::datatable(df)
  }
  else {
    View(df, title = as.character(df_name[[1]]))
  }
}
