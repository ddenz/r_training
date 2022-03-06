library(targets)

source("plot_covid_cases_by_age_group.R")

options(tidyverse.quiet = TRUE)

tar_option_set(packages = c("tidyverse", "ggplot2"))

list(
  tar_target(
    data,
    load_data()
  ),
  tar_target(
    plot,
    plot_data(data)
  ),
  tar_target(
    display,
    print(plot)
  )
)