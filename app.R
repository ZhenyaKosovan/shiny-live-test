library(shiny)
library(bslib)
library(highcharter)
library(reactable)

library(readr)
library(dplyr)
library(lubridate)
library(stringr)
library(tidyr)
source("./R/generate_ui_elements.R")

# read metadata
top_tickers <- read_csv("./metadata/top_10_tickers.csv",
                        show_col_types = F) %>%
  mutate(ref_date = as.Date(paste(ref_year, ref_month, "01", sep = "-")))

ui <- page_fluid(
  `enable-shadows` = TRUE,
  title = "Top 10 S&P 500 Tickers by Cumulative Return",
  layout_columns(
    card(card_header("Navigation"),
         dateInput("start_date", "Start Date", 
                   format = "yyyy-mm", 
                   startview = "year",
                   value = "2022-06"),
         dateInput("end_date", "End Date", value = "2024-05-01")
    ),
    card(
      card(
        card_header(textOutput("table_title")),
        reactableOutput("cumulative_return_table"),
        height = '200px',
      ),
      card(
        card_header("Monthly Cumulative Return"),
        highchartOutput("cumulative_return_plot"),
        height = '500px',
        full_screen = TRUE
      )
    ),
    col_widths = c(3, 9)
  )
)

server <- function(input, output, session) {

  output$cumulative_return_plot <- renderHighchart({
    generate_cumulative_return_plot(data = top_tickers,
                                    start_date = input$start_date,
                                    end_date = input$end_date)
  })
  
  cumulative_return_table <- reactive({
    generate_cumulative_return_table(data = top_tickers,
                                     start_date = input$start_date,
                                     end_date = input$end_date)
  })
  output$table_title <- renderText({str_glue("Cumulative Return as of {format(cumulative_return_table()$last_date, '%B %Y')}")})
  output$cumulative_return_table <- renderReactable({
    cumulative_return_table()$tbl
  })
}

shinyApp(ui = ui, server = server)
