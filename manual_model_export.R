delay <- filtered_delay_data
fitted1 <- lm(delay~ weekday +
                vehicle_type +
                windspeed_max +
                humidity +
                precipitation +
                temp, delay,
              model = FALSE, qr = TRUE, y = FALSE)
#fitted1 <- lm(delay~weekday, delay,
#          model = FALSE, qr = TRUE, y = FALSE)

summary(fitted1)
fitted1$fitted.values <- NULL
fitted1$residuals <- NULL
fitted1$na.action <- NULL
fitted1$effects <- NULL
fitted1$qr$qr <- NULL
lapply(fitted1, object.size)
object.size(fitted1)
library("readr")

predict(fitted1, newdata = delay[1,])

write_rds(fitted1, "model")
