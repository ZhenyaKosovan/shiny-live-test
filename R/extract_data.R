# library(tidyverse)
# library(yfR)
# 
# 
# # download SP500 tickers
# sp500 <- yf_collection_get('SP500', 
#                            last_date = '2024-06-01', 
#                            first_date = '2015-06-01',
#                            freq_data = 'monthly',
#                            be_quiet = T)
# # find top 10 highest average close price over the last months
# 
# top_tickers <- sp500 %>% 
#   filter(ref_date == max(ref_date)) %>%
#   arrange(desc(cumret_adjusted_prices)) %>%
#   slice(1:10)
# # save as metadata
# sp500 %>% 
#   filter(ticker %in% top_tickers$ticker) %>% 
#   mutate(ref_month = month(ref_date),
#          ref_year = year(ref_date)) %>%
#   summarise(across(price_open:cumret_adjusted_prices, mean, na.rm = T),
#          .by = c(ticker, ref_month, ref_year)
#   ) %>%
#   write_csv("./metadata/top_10_tickers.csv")
