add_delay_data_attributes <- function(delay_data) {
  delay_data %>%
    add_weekday %>%
    add_delay
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
