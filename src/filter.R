add_delay_data_attributes <- function(delay_data, vbz_lines) {
  delay_data %>%
    add_weekday %>%
    add_delay %>%
    add_vehicle_type(vbz_lines)
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
