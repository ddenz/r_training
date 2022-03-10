library(tidyverse)

# set time zone to NZT to make sure we retrieve the correct date
Sys.setenv(TZ='Pacific/Auckland')

# function definitions

load_data <- function() {
  # for now this will only work once the day's figures have been released
  #url <- paste('https://www.health.govt.nz/system/files/documents/pages/', Sys.Date(), '.csv', sep='')
  #filename <- sapply(str_split(url, '/'), tail, 1)
  filename <- "covid_cases_2022-03-02.csv"
  #download.file(url, filename)
  data <- read.csv(filename)
  return(data)
}

plot_data <- function(data) {
  p <- ggplot(data = data, aes(x=Age.group, fill=DHB)) + 
    geom_bar() + 
    ggtitle('COVID-19 cases per age group') + 
    theme(plot.title = element_text(hjust = 0.5)) +
    xlab('Age group') + 
    ylab('Count')
  return(p)
}

plot_time_series <- function(data) {
  data <- data.frame(table(data['Report.Date']))
  colnames(data) <- c('Date', 'Count')
  p <- ggplot(data = data, aes(x=as.Date(Date), y=Count)) +
    geom_line() +
    ggtitle('COVID-19 cases per day') +
    theme(plot.title = element_text((hjust = 0.5))) +
    xlab('Date') +
    ylab('Count')
  return(p)
}

data <- load_data()
p <- plot_data(data)
print(p)

#p <- plot_time_series(data)
#print(p)