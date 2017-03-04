read_soll_ist <- function(path) {
  readr::read_delim(path, delim = ",")
}

read_timeslots <- function(path) {
  readr::read_delim(path, delim = ",")
}
