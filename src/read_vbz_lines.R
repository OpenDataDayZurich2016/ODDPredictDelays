read_vbz_lines <- function(path) {
  data <- readr::read_delim(path, delim = ";")
  names(data)[[1]] <- "linie"
  data
}
