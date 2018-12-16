#' Compile and browse an individual chapter
#'
#' @param chapter_file name of the local file to preview
#'
#' @return browse
#' @importFrom bookdown preview_chapter
#' @importFrom utils browseURL
#' @export
#'
#' @examples
#' \dontrun{sp_preview_chapter("chapter_file.Rmd")}
sp_preview_chapter <- function(chapter_file) {
    preview_url <- preview_chapter(chapter_file)
    browseURL(preview_url)
}
