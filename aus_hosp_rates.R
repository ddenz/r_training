library(tidyverse)
library(zoo)

# TODO update this to use the COOVID19 library
#library('COVID19')
#data <- covid19()

states <- list(tas = 'https://storage.covid19datahub.io/location/86525f8e.csv',
               qld = 'https://storage.covid19datahub.io/location/36068882.csv',
               nsw = 'https://storage.covid19datahub.io/location/5c4dd6e0.csv',
               wa = 'https://storage.covid19datahub.io/location/1f999f12.csv',
               nt = 'https://storage.covid19datahub.io/location/a079fdb2.csv',
               sa = 'https://storage.covid19datahub.io/location/165128d0.csv',
               act = 'https://storage.covid19datahub.io/location/f42f23e3.csv')

download_all_data <- function(url_map) {
  for (name in names(url_map)) {
    filename <- paste0(name, '.csv')
    url = url_map[[name]]
    download.file(url, filename)
  }
}

load_data <- function(state_code) {
  filename <- paste0(state_code, '.csv')
  data <- read.csv(filename)
  data$date <- as.Date(data$date)
  return(data)
}

prepare_data <- function(data, state_code, n_days) {
  data <- data %>%
    dplyr::mutate(hosp_nd = zoo::rollmean(data$hosp, k = n_days, fill = NA)) %>%
    dplyer::select(c(data, hosp_nd))
  data$state <- state_code
  return(data)
}

plot_time_series <- function(data, state_code) {
  # calculate 4-day and 10-day rolling averages of hospitalisations,
  # keep only the required columns
  data <- data %>%
    dplyr::mutate(hosp_04d = zoo::rollmean(data$hosp, k = 4, fill= NA),
                  hosp_10d = zoo::rollmean(data$hosp, k = 10, fill= NA)) %>%
    dplyr::select(c(date, hosp, hosp_04d, hosp_10d))

  p <- data %>% tidyr::pivot_longer(names_to = "rolling_mean_key",
                               values_to = "rolling_mean_value",
                               cols = c(hosp, hosp_04d, hosp_10d)) %>%
    ggplot(aes(x = date, y = rolling_mean_value, color = rolling_mean_key)) +
    geom_line() + ggtitle(toupper(state_code))
  return(p)
}

# do this first to download the data
#download_all_data(states)

# create a plot for each state and write to disk
for (name in names(states)) {
  data <- load_data(name)
  p <- plot_time_series(data, name)
  print(p)
  dev.copy(png, paste0('outputs/', name, '_time_series.png'))
}
