library(tidyverse)
library(ggplot2)

# set time zone to NZT to make sure we retrieve the correct date
Sys.setenv(TZ='Pacific/Auckland')

# function definitions

load_data <- function() {
  # for now this will only work once the day's figures have been released
  url <- paste('https://www.health.govt.nz/system/files/documents/pages/', Sys.Date(), '.csv', sep='')
  filename <- sapply(str_split(url, '/'), tail, 1)
  download.file(url, filename)
  data <- read.csv(filename)
  return(data)
}

plot_data <- function(data) {
  p <- ggplot(data = data, aes(x=Age.group)) + 
    geom_bar() + 
    ggtitle('COVID-19 cases per age group') + 
    theme(plot.title = element_text(hjust = 0.5)) +
    xlab('Age group') + 
    ylab('Count')
  return(p)
}

data <- load_data()
p <- plot_data(data)
print(p)