#' Download a table from the dbms and create a data dictionary data frame
#'
#' @param table_name The name of a table to be processed.
#' @param con A DBI connection object for obtaining the local copy to be processed
#'
#' @return a data frame `table_dd`
#' @export
#' @importFrom dplyr %>%
#' @importFrom dplyr tbl
#' @importFrom dplyr collect
#'
#' @examples # all_meta <- sp_get_dbms_data_dictionary("rental")
sp_get_dbms_data_dictionary <- function(table_name, con = con) {
  table_ptr <- tbl(con, table_name)
  local_df <- table_ptr %>% collect(n = Inf)
  table_dd <- sp_make_data_dictionary(local_df, df_alias = table_name)
}
