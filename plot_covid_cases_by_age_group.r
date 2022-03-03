library(tidyverse)
library(ggplot2)

# function definitions

load_data <- function(url) {
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

data <- load_data('https://www.health.govt.nz/system/files/documents/pages/covid_cases_2022-03-03.csv')
p <- plot_data(data)
print(p)