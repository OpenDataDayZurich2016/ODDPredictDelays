library("OpenML")
library("remake")
library("dplyr")
library("lubridate")

setwd("..")
make("filtered_delay_data", remake_file = "remake.yml")
delaydat <- fetch("filtered_delay_data")

openml_delaydat <- select(delaydat,
                          delay,
                          vehicle_type, line_number = Linienname_Fahrgastauskunft,
                          direction = richtung, stop_id = halt_punkt_id_von,
                          weekday, time,
                          temp, windspeed_max, windspeed_avg,
                          precipitation, dew_point, humidity)

openml_delaydat <- mutate(openml_delaydat,
                          hour = hour(time),
                          dayminute = hour * 60 + minute(time))

# ### Upload subsample
# set.seed(2017)
# ss <- sample(1:nrow(openml_delaydat), size = 30)
# openml_delaydat_s <- as.data.frame(openml_delaydat[ss, ])
# openml_delaydat_s$time <- as.character(openml_delaydat_s$time)
# 
# dsc_s <- "Subsample of Zurich public transport delay data 2016-10-30 03:30:00 CET - 2016-11-27 01:20:00 CET cleaned and prepared at Open Data Day 2017."
# 
# delay_descr_s <- makeOMLDataSetDescription(
#   name = "subsample_delays_zurich_transport",
#   description = dsc_s,
#   contributor = "https://github.com/OpenDataDayZurich2016/ODDPredictDelays/graphs/contributors",
#   # collection.date = "2016-10-30 03:30:00 CET - 2016-11-27 01:20:00 CET",
#   licence = "CCZero",
#   default.target.attribute = "delay",
#   citation = "https://github.com/OpenDataDayZurich2016/ODDPredictDelays",
#   original.data.url = "https://data.stadt-zuerich.ch/dataset/vbz-fahrzeiten-ogd"
# )
# 
# oml_delay <- makeOMLDataSet(desc = delay_descr_s,
#                             data = openml_delaydat_s,
#                             target.features = "delay")
# 
# uploadOMLDataSet(oml_delay, confirm.upload = FALSE)


### Upload all
dsc <- "Zurich public transport delay data 2016-10-30 03:30:00 CET - 2016-11-27 01:20:00 CET cleaned and prepared at Open Data Day 2017."

delay_descr <- makeOMLDataSetDescription(
  name = "delays_zurich_transport",
  description = dsc,
  contributor = "https://github.com/OpenDataDayZurich2016/ODDPredictDelays/graphs/contributors",
  # collection.date = "2016-10-30 03:30:00 CET - 2016-11-27 01:20:00 CET",
  licence = "CCZero",
  default.target.attribute = "delay",
  citation = "https://github.com/OpenDataDayZurich2016/ODDPredictDelays",
  original.data.url = "https://data.stadt-zuerich.ch/dataset/vbz-fahrzeiten-ogd"
  )

openml_delaydat <- as.data.frame(openml_delaydat)
openml_delaydat$time <- as.character(openml_delaydat$time)

oml_delay <- makeOMLDataSet(desc = delay_descr,
                            data = openml_delaydat,
                            target.features = "delay")

uploadOMLDataSet(oml_delay)

