library(targets)

source("plot_covid_cases_by_age_group.R")

options(tidyverse.quiet = TRUE)

tar_option_set(packages = c("tidyverse", "ggplot2"))

list(
  tar_target(
    raw_data_file,
    "covid_cases_2022-03-02.csv",
    format = file
  ),
  tar_target(
    data,
    read_csv(raw_data_file, col_types = cols())
  ),
#  tar_target(
#    data,
#    load_data()
#  ),
  tar_target(
    plot,
    plot_data(data)
  ),
  tar_target(
    display,
    print(plot)
  )
)