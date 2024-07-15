#' @title Write fmi2 data into cache
#' @description Helper function that writes FMI dataset into cache.
#'
#' @param cache A logical whether to do caching.
#' @param cache_dir A path to the cache directory.
#' @param query_hash A character string used to identify the dataset.
#' @param data FMI dataset
#' @param meta A logical whether also save the dataset metadata.
#'
#' @keywords internal
write_fmi2_cache <- function(cache, cache_dir, query_hash, data, meta){
  # Check if data should be written to cache
  if (cache) {
    if (is.null(cache_dir)) {
      cache_dir <- file.path(tempdir(), "fmi2")
      cache_dir <- path.expand(cache_dir)
    }
    # Check if the cache dir exists. If not creates cache dir.
    if (!dir.exists(cache_dir)) {
      dir.create(cache_dir, recursive = TRUE)
    }
    # Write data into cache
    cache_file <- file.path(cache_dir, paste0(query_hash, ".gpkg"))
    sf::st_write(data, cache_file, driver = "GPKG", quiet = TRUE)

    # Write metadata into cache
    if (meta) {
      attri <- attributes(data)
      meta_file <- file.path(cache_dir, paste0(query_hash, "_meta.rds"))
      saveRDS(attri, file = meta_file, compress = TRUE)
    }
  }
}


#' @title Read cache for fmi2 data
#' @description Helper function that reads cache for saved FMI dataset.
#'
#' @param cache A logical whether to check cache.
#' @param cache_dir A path to the cache directory.
#' @param query_hash A character string used to identify the dataset.
#' @param meta A logical whether to also read the dataset metadata.
#'
#' @return sf object or `NULL`
#'
#' @keywords internal
read_fmi2_cache <- function(cache, cache_dir, query_hash, meta){
  # Check if cache should be checked
  if (cache) {
    if (is.null(cache_dir)) {
      cache_dir <- file.path(tempdir(), "fmi2")
      cache_dir <- path.expand(cache_dir)
    }
    # Check if cache dir exists.
    if (dir.exists(cache_dir)){
      cache_file <- file.path(cache_dir, paste0(query_hash, ".gpkg"))
      # Check if file exists
      if (file.exists(cache_file)){
        y <- sf::st_read(cache_file, quiet = TRUE)
        if (meta) {
          # Add metadata back into the data
          meta_file <- file.path(cache_dir, paste0(query_hash, "_meta.rds"))
          ym <- readRDS(meta_file)
          attr(y, "title") <- ym$title
          attr(y, "organization") <- ym$organization
          attr(y, "time_stamp") <- ym$time_stamp
          attr(y, "parameters") <- ym$parameters
          attr(y, "url") <- ym$url
          return(y)
        } else {
          return(y)
        }
      } else {
        return(NULL)
      }
    } else {
      return(NULL)
    }
  }
}


#' @title Clean fmi2 cache
#' @description Delete all .gpkg files from the fmi2 cache directory.
#'
#' @param cache_dir A path to the cache directory. If `NULL` (default) tries to clean temporary
#' cache directory.
#'
#' @examples
#'   \dontrun{
#'   clean_fmi2_cache()
#'   }
#' @export
clean_fmi2_cache <- function(cache_dir = NULL){
  if (is.null(cache_dir)) {
    cache_dir <- file.path(tempdir(), "fmi2")
    cache_dir <- path.expand(cache_dir)
  }
  # Check that cache dir exists.
  if (!dir.exists(cache_dir)){
    message("The cache directory does not exist.")
  } else if (dir.exists(cache_dir)) {
    # Get cache file names
    files <- list.files(cache_dir,
                        pattern = "*.(gpkg|rds)$",
                        full.names = TRUE)
  }
  # Check that cache had files
  if (length(files) == 0) {
    message("The cache folder ", cache_dir, " is empty.")
  } else {
    # Delete cache files
    unlink(files)
    message("Deleted .gpkg and .rds files from ", cache_dir)
  }
  invisible(TRUE)
}
