create_model <- function(filtered_delay_data) {
  delay <- filtered_delay_data
  fit <- lm(
    delay ~ weekday + vehicle_type + temp + precipitation,
    delay, model = FALSE, qr = TRUE, y = FALSE
  )
  print(summary(fit))
  fit$fitted.values <- NULL
  fit$residuals <- NULL
  fit$na.action <- NULL
  fit$effects <- NULL
  fit$qr$qr <- NULL
  fit
}
