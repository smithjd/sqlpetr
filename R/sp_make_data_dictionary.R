#' Run sp_get_fivenumsum on all variables in a data frame
#'
#' @param df data frame to be summarized
#' @param df_alias name of the data frame to be appended
#'
#' @return a data frame
#' @export
#' @importFrom tibble as_tibble
#' @importFrom tibble tibble
#' @importFrom purrr map
#' @importFrom purrr map_chr
#'
#' @examples table_dd <- sp_make_data_dictionary(mtcars)
sp_make_data_dictionary <- function(df, df_alias = NULL){
  df_name <- substitute(df)
  if (!is.null(df_alias)) {df_name <- df_alias}
  n_of_vars_in_df <- dim(df)[2]
  data_frame_info <- tibble::as_tibble(rep(as.character(df_name),n_of_vars_in_df))
  var_name_list <- as.character(names(df))
  fivesum <- purrr::map(df,sp_get_fivenumsum) %>% dplyr::bind_rows()
  fivesum <- dplyr::bind_cols(tibble::tibble(var_name = var_name_list), fivesum)
  var_type_info <- tibble::tibble(var_name = names(df), var_type = purrr::map_chr(df, typeof))
  names(data_frame_info) <- "table_name"
  dd_out <- dplyr::left_join(var_type_info, fivesum, by = "var_name")
  dd_out <- dplyr::bind_cols(data_frame_info,dd_out)
  dd_out
}
