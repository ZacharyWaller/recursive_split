library(purrr)
library(rrapply)

source("R/functions.R")

# Example ----------------------------------------------------------------------
size <- 500
data <- data.frame(
  x = sample(letters[1:3], size = size, replace = TRUE),
  y = sample(letters[24:26], size = size, replace = TRUE),
  z = sample(letters[13:14], size = size, replace = TRUE),
  a = sample(letters[9:12], size = size, replace = TRUE),
  value1 = rnorm(n = size),
  value2 = rnorm(n = size, mean = 10),
  stringsAsFactors = FALSE
)

split_columns <- c("x", "y", "z", "a")

# make a big recursive list with all our data in
data_list <- apply_recursive_split(data, split_columns)

# you can do some fun things here to index it:
data_list[[c("a", "x", "m", "l")]]

# rebind the data together into a data.frame
rebound_data <- rebind(data_list)

identical(rebound_data, data)


# Tibbles ----------------------------------------------------------------------
# with tibbles we lose order, but the data is still the same
library(tibble)

data_tibble <- tibble(
  x = sample(letters[1:3], size = size, replace = TRUE),
  y = sample(letters[24:26], size = size, replace = TRUE),
  z = sample(letters[13:14], size = size, replace = TRUE),
  a = sample(letters[9:12], size = size, replace = TRUE),
  value1 = rnorm(n = size),
  value2 = rnorm(n = size, mean = 10)
)

rebound_tibble <- apply_recursive_split(data_tibble, split_columns) %>%
  rebind()

# tibbles have no row names, so we lose order!
identical(data_tibble, rebound_tibble)

# the data is still the same though
identical(
  arrange(rebound_tibble, x, y, z, a, value1, value2),
  arrange(data_tibble, x, y, z, a, value1, value2)
)
