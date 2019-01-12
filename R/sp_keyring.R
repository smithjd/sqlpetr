#' @title Set a key into the default keyring
#' @name sp_set_key
#' @description sets a key into the default keyring
#' @importFrom keyring key_set_with_value
#' @export sp_set_key
#' @param key_name the name of the key
#' @param key_value the value to set
#' @details `sqlpetr` uses the `keyring` package to manage secrets as key-value
#' pairs. This is portable; it will work on any platform where `keyring` can be
#' installed, including Linux, MacOS and Windows.
#'
#' @examples
#' \dontrun{
#' sp_set_key(key_name = "POSTGRES_PASSWORD", key_value = "postgres")
#' }

sp_set_key <- function(key_name, key_value) {
  keyring::key_set_with_value(
    service = key_name, password = key_value, keyring = "")
}

#' @title Get a key from the keyring
#' @name sp_get_key
#' @description gets a key previously set into the keyring
#' @importFrom keyring key_get
#' @export sp_get_key
#' @param key_name the name of the key to get
#' @return the key_value
#'
#' @examples
#' \dontrun{
#' sp_get_key(key_name = "POSTGRES_PASSWORD")
#' }
sp_get_key <- function(key_name) {
  return(keyring::key_get(service = key_name, keyring = ""))
}
