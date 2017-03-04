read_weather <- function(path) {
  data <- suppressWarnings(
    readxl::read_excel(path, skip = 5)
  )
  names(data) <- c(
    "time",
    "temp",
    "windspeed_max",
    "windspeed_avg",
    "windspeet_avg_bft",
    "precipitation",
    "dew_point",
    "humidity"
  )
  data %>%
    filter(lubridate::year(time) == YEAR) %>%
    mutate(time = lubridate::`tz<-`(time, "CET"))
}
