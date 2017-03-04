create_model <- function(filtered_delay_data) {
  res <- lm(
    delay ~ weekday + vehicle_type + factor(temp > 10) + factor(precipitation > 0),
    filtered_delay_data, model = FALSE, qr = TRUE, y = FALSE
  )
  print(summary(res))
  res$rested.values <- NULL
  res$residuals <- NULL
  res$na.action <- NULL
  res$effects <- NULL
  res$qr$qr <- NULL
  res
}
