read_soll_ist <- function(timeslots, year, month) {
  year <- 2016
  month <- 11
  first <- as.Date(sprintf("%s-%s-01", year, month))
  last <- as.Date(sprintf("%s-%s-23", year, month))
  our_timeslots <-
    timeslots %>%
    filter(as.Date(from) < last & as.Date(to) > first)

  paths <- file.path("raw/data/delay_data", our_timeslots$filename)
  all_datasets <- parallel::mclapply(paths, read_soll_ist_one)
  bind_rows(all_datasets)
}

read_soll_ist_one <- function(path) {
  data <- readr::read_delim(path, delim = ",")
  names(data)[[1]] <- "linie"
  data
}

read_timeslots <- function(path) {
  readr::read_delim(path, delim = ",")
}

read_stations <- function(path) {
  readr::read_delim(path, delim = ",")
}
