# app.R

library(readr)

# Read the CSV file
file_changes <- read_csv('file_changes.csv')

# Print the file changes
print(file_changes)