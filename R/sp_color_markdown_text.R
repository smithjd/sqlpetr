#' Color subsequent text in a specified color
#'
#' @param x a string
#' @param color color to apply
#'
#' @return colored string
#' @export
#'
#' @examples # sp_color_markdown_text('Cover inline tables in future section','red')
sp_color_markdown_text <- function(x,color)
{
  outputFormat = knitr::opts_knit$get("rmarkdown.pandoc.to")
  if (outputFormat == 'latex')
    paste0("\\textcolor{",color,"}{",x,"}")
  else if (outputFormat == 'html')
    paste0("<font color='",color,"'>",x,"</font>")
  else
    x
}
