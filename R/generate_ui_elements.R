
generate_cumulative_return_plot <- function(data,
                                            start_date = "2015-06-01",
                                            end_date = "2024-05-01") {

  chart_data <- data %>%
    filter(ref_date >= ymd(start_date),
           ref_date <= ymd(end_date)) %>%
    mutate(starting_cum_ret = max(if_else(ref_date == start_date, 
                                          cumret_adjusted_prices, 
                                          NA_real_), na.rm = TRUE),
           cum_ret = cumret_adjusted_prices - starting_cum_ret,
           .by = ticker)
  
  min_return <-  chart_data$cum_ret %>% min()
  max_return <-  chart_data$cum_ret %>% max()

  hc <- hchart(chart_data, "line", 
               hcaes(x = ref_date, 
                     y = cum_ret, 
                     group = ticker)) %>% 
    hc_title(text = "Top 10 S&P 500 Tickers by Cumulative Return") %>%  
    hc_yAxis(
      labels = list(format = "{value}%"),
      title = list(text = ""),
      floor = min_return,
      ceiling = max_return) %>% 
    hc_xAxis(
      title = list(text = "")
    ) %>% 
    hc_plotOptions(series = list(marker = list(enabled = FALSE)))
  return(hc)
}
# library(highcharter)
# library(dplyr)
# library(readr)
# 
# # read metadata
# top_tickers <- read_csv("./metadata/top_10_tickers.csv") %>%
#   mutate(ref_date = as.Date(paste(ref_year, ref_month, "01", sep = "-")))
# 
# 
# generate_cumulative_return_plot(data = top_tickers,
#                                 start_date = '2022-06-01')


generate_cumulative_return_table <- function(data,
                                            start_date = "2015-06-01",
                                            end_date = "2024-05-01") {

  
  chart_data <- data %>%
    filter(ref_date >= ymd(start_date),
           ref_date <= ymd(end_date)) %>%
    mutate(starting_cum_ret = max(if_else(ref_date == start_date, 
                                          cumret_adjusted_prices, 
                                          NA_real_), na.rm = TRUE),
           cum_ret = cumret_adjusted_prices - starting_cum_ret,
           .by = ticker)
  
  
  last_date <- chart_data$ref_date %>% max()
  tbl <-   reactable(
    chart_data %>%
      filter(ref_date == max(ref_date)) %>%
      select(ticker, cum_ret) %>%
      mutate(cum_ret = round(cum_ret / 100, 4)) %>%
      pivot_wider(names_from = ticker, values_from = cum_ret),
    defaultColDef = colDef(format = colFormat(percent = TRUE))
  )
  
  return(list(last_date = last_date,
              tbl = tbl))

}
# 
# generate_cumulative_return_table(data = top_tickers)
