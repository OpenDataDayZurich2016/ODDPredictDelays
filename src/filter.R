add_delay_data_attributes <- function(delay_data, vbz_lines, weather_2016) {
  delay_data %>%
    add_weekday %>%
    add_delay %>%
    add_vehicle_type(vbz_lines) %>%
    add_weather_data(delay_data, weather_2016)
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
    trunc(diff / bin_size_min)
  }

  weather_bin <-
    weather_2016 %>%
    filter(!is.na(time)) %>%
    mutate(time_bin = bin_time(time))
  delay_data_bin <-
    delay_data %>%
    mutate(time_bin = bin_time(
      as.POSIXct(datum_von, format = "%d.%m.%y", tz = "CET") +
        soll_ab_von)
    )

  delay_data_bin %>%
    left_join(weather_bin, by = "time_bin") %>%
    select(-time_bin)
}
