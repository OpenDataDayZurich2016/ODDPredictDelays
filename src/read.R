read_soll_ist <- function(path) {
  data <- readr::read_delim(path, delim = ",")
  names(data)[[1]] <- "linie"
  data
}

read_timeslots <- function(path) {
  readr::read_delim(path, delim = ",")
}
