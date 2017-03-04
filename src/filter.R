add_delay_data_attributes <- function(delay_data, vbz_lines, weather_2016) {
  delay_data %>%
    add_weekday %>%
    add_delay %>%
    add_vehicle_type(vbz_lines) %>%
    add_weather_data(weather_2016)
}

add_weekday <- function(delay_data) {
  delay_data %>%
    mutate(
      weekday = factor(lubridate::wday(betriebsdatum %>% as.Date(format = "%d.%m.%Y")))
    )
}

add_delay <- function(delay_data) {
  delay_data %>%
    mutate(
      delay = ist_an_von - soll_an_von,
      delay_next = ist_an_nach1 - soll_an_nach
    )
}

add_vehicle_type <- function(delay_data, vbz_lines) {
  vbz_lines_loc <- vbz_lines %>%
    add_row(Linienname = c(83, 701:705),
            VSYS = rep("B", 6))

  delay <- left_join(delay_data, vbz_lines_loc, by = c("linie" = "Linienname")) %>%
    select(-linie.y)

  print(setdiff(unique(delay_data$linie), unique(vbz_lines_loc$Linienname)))


  # check NA
  print(table(is.na(delay$linie)))

  # which VSYS are in data?
  print(table(delay$VSYS))
  translate <- data_frame(
    "VSYS" = c("T", "Bus", "B", "BL", "BG", "BP", "BZ", "SB", "TR", "N", "FB"),
    "vehicle_type" = c("Tram",
                       rep("Bus", 6),
                       "funicular",
                       "Trolley",
                       "T",
                       "FB")
  )
  delay <- left_join(delay, translate)
  unique(delay$VSYS)
  table(is.na(delay$vehicle_type))

  delay
}

add_weather_data <- function(delay_data, weather_2016) {
  base_time <- weather_2016$time[[1]]
  bin_time <- function(time) {
    bin_size_min <- 10 * 60
    diff <- time - base_time
    units(diff) <- "secs"
    diff <- as.numeric(diff)
    round(diff / bin_size_min)
  }

  weather_bin <-
    weather_2016 %>%
    filter(!is.na(time)) %>%
    mutate(time_bin = bin_time(time)) # %>%
    # clean_weather_bins

  stopifnot(!anyDuplicated(weather_bin$time_bin))

  delay_data_bin <-
    delay_data %>%
    mutate(time_bin = bin_time(
      as.POSIXct(datum_von, format = "%d.%m.%y", tz = "CET") +
        soll_ab_von)
    )

  ret <-
    delay_data_bin %>%
    left_join(weather_bin, by = "time_bin")

  stopifnot(nrow(ret) == nrow(delay_data_bin))

  # FIXME: This loses a few observations, a better way would be to clean the
  # weather data (see clean_weather_bins())
  ret <-
    ret %>%
    filter(!is.na(time)) %>%
    select(-time_bin)

  stopifnot(!anyNA(ret$time))
  ret
}

clean_weather_bins <- function(weather_bins) {
  all_bins <- seq(from = min(weather_bins$time_bin), to = max(weather_bins$time_bin))
  missing_bins <- setdiff(all_bins, weather_bins$time_bin)
  stopifnot(diff(sort(missing_bins) > 1))
  replacement_bins <- missing_bins - 1
  relabel_bins <- data_frame(new_time_bin = replacement_bins, time_bin = missing_bins)
  relabel_bins %>%
    left_join(weather_bins, by = "time_bin") %>%
    select(-time_bin) %>%
    rename(time_bin = new_time_bin) %>%
    bind_rows(weather_bins) %>%
    arrange(time_bin)
}
