YEAR <- 2016

read_soll_ist <- function(timeslots, year, month) {
  year <- YEAR
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
  data <- readr::read_delim(
    path,
    delim = ",",
    col_types = cols(
      fahrzeug = col_skip(), kurs = col_skip(), halt_diva_von = col_skip(),
      halt_kurz_von1 = col_skip(), seq_nach = col_skip(),
      halt_diva_nach = col_skip(), halt_punkt_diva_nach = col_skip(),
      halt_kurz_nach1 = col_skip(), datum_nach = col_skip(), fahrt_id = col_skip(),
      fahrweg_id = col_skip(), fw_no = col_skip(), fw_typ = col_skip(),
      fw_kurz = col_skip(), fw_lang = col_skip(), umlauf_von = col_skip(),
      halt_id_von = col_skip(), halt_id_nach = col_skip(),
      halt_punkt_id_nach = col_skip()
    )
  )
  names(data)[[1]] <- "linie"
  data
}

read_timeslots <- function(path) {
  readr::read_delim(path, delim = ",")
}

read_stations <- function(path) {
  readr::read_delim(path, delim = ",")
}
