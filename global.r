library(shiny)
library(tidyverse)
library(DT)
library(shinyjs)
library(glue)
library(shinydashboard)
library(googlesheets4)

options(
  gargle_oauth_email = "lucydagostino@gmail.com"
)

gs4_deauth()


fix_data <- function(d) {
  names(d) <- gsub("Cases in Teachers", "Cases in Staff", names(d))
  start <- grep("Open", names(d))[1]
  end <- ncol(d)
  len <- (end - start + 1) / 5
  dates <- seq(as.Date("2020-06-15"), by = 7, length.out = len)
  d %>%
    pivot_longer(start:end,
      names_to = c(".value"),
      names_pattern = "^(.+?)\\."
    ) %>%
    add_column(
      `Week of` = rep(dates, length.out = nrow(.)),
      .before = "Open?"
    ) %>%
    mutate(`Type of Institution` = factor(`Type of Institution`)) %>%
    mutate(State = factor(State)) %>%
    mutate(County = factor(County)) %>%
    replace_na(list(`Open?` = "--")) %>%
    mutate(`Open?` = factor(`Open?`))

}

