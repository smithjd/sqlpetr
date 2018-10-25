#' @title Make Image Files
#' @name sp_make_image_files
#' @description Creates image files from a DiagrammeR `htmlwidget` object
#' @importFrom DiagrammeRsvg export_svg
#' @importFrom magick image_read_svg
#' @importFrom magick image_write
#' @importFrom dplyr %>%
#' @export sp_make_image_files
#' @param widget an `htmlwidget` object returned from DiagrammeR, usually from
#' `grViz` or `render_graph`
#' @param directory (character) a valid file path. Default is ".". If it does not
#' exist it will be created.
#' @param filename (character) a valid file name (stem only). Three files will be
#' overwritten if they exist and created if they don't:
#' \itemize{
#' \item <directory>/<filename>.svg
#' \item <directory>/<filename>.png
#' \item <directory>/<filename>.pdf
#' }
#' @return png_name (character) the name of the PNG file. This is the path you
#' give to `knitr::include_graphics` for the `auto_pdf` option.
#' @details See the vignette "Using DiagrammeR with Bookdown" for the derivation
#' and some examples.

sp_make_image_files <- function(
  widget, directory = "diagrams", filename = "example") {

  dir.create(directory, recursive = TRUE)
  svg_name <- paste(
    directory, paste(filename, "svg", sep = "."), sep = "/")
  png_name <- paste(
    directory, paste(filename, "png", sep = "."), sep = "/")
  pdf_name <- paste(
    directory, paste(filename, "pdf", sep = "."), sep = "/")
  widget %>%  DiagrammeRsvg::export_svg() %>%
    cat(file = svg_name)
  magick::image_read_svg(svg_name) %>%
    magick::image_write(path = png_name, format = "png")
  magick::image_read_svg(svg_name) %>%
    magick::image_write(path = pdf_name, format = "pdf")

  # return the PNG file name; it's an argument to `knitr::include_graphics`
  return(png_name)

}
