filter_delay_data <- function(delay_data) {
  delay_data %>%
    mutate(
      weekday = factor(lubridate::wday(betriebsdatum %>% as.Date(format = "%d.%m.%Y"))),
      delay = ist_an_von - soll_an_von
    )
}
