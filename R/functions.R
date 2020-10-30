# Just the usual split function from r, but takes the split factor from
# a column in the dataframe
split_function <- function(x, column){ 
  
  split(x, f = x[[column]]) 
  
}

# rrapply will apply our split function to our list no matter how nested it is.
# this means we don't have to mess around with nested loops.
# Works like base rapply but is way more flexible
recursive_split <- function(data, column){
  rrapply(
    data,
    f = split_function,
    dfaslist = FALSE,
    how = "replace",
    column = column
  )
}

# apply the recursive split function for each column.
# have to put the data in a list at first to avoid treating the data.frame as a
# list. the last step subsets the answer to cancel out this initial list-ing.
# slightly sneaky use of .init argument to make it clear that argument 1 and 2 
# are different. we're essentially doing:
# f(data, column_1) %>% f(column_2) %>% f(column_3) ....
apply_recursive_split <- function(data, columns){
  
  data_list <- list(data)
  
  result <- reduce(
    .x = columns,
    .f = recursive_split,
    .init = data_list
  )
  
  result[[1]]
}

# rebind the data into a data.frame
rebind <- function(data){
  
  # we can flatten our nested list into one list of data.frames and bind together
  flat_data_list <- rrapply(
    data,
    f = identity,
    dfaslist = FALSE,
    how = "flatten"
  )
  
  # go along the list binding everything up
  rebound_data <- reduce(flat_data_list, rbind)
  
  # the original split keeps row names which we can use to reorder and be 
  # identical to the original data.frame
  # pretty sneaky. won't work with tibbles I imagine
  order <- as.character(1:nrow(rebound_data))
  
  rebound_data[order, ]
  
}

