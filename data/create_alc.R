#Johanna Lehtinen
#15.11.2023

#Code for data wrangling part of assignment 3 in IOODS2023 course. 
#Data is available at https://www.archive.ics.uci.edu/dataset/320/student+performance

#librarys
library(tidyverse)
library(dplyr)

#read in the data files. read_csv2 command is expecting the data have ";" as a separator. 

mat <-  read_csv2("data/student-mat.csv")
por <-  read_csv2("data/student-por.csv")

#structure of the data
str(mat)
dim(mat)
head(mat)

str(por)
dim(por)
head(por)

#check the column names
colnames(math); colnames(por)

#everything looks good!

#join the data sets

#Create vector of columns that we dont want to use in combining
out_cols <- c("failures", "paid", "absences", "G1", "G2", "G3")

#create other vector including all the rest columns
join_cols <- setdiff(colnames(por), out_cols)

# join the two data sets by the created vector, the suffix part defines from which file the column is originally 
math_por <- inner_join(math, por, by = join_cols, suffix = c(".math", ".por"))

#create new data frame from math_por that includes only columns that are not duplicates
alc <- select(math_por, all_of(join_cols))

#for loop that goes trough all the column names that are duplicates
for(col_name in out_cols) {
  #select both duplicated columns
  two_cols <- select(math_por, starts_with(col_name))
  #select one of those columns
  first_col <- select(two_cols, 1)[[1]]
  #if the selected column is numeric then do the next part
  if(is.numeric(first_col)) {
    #include the column in the alc data frame by taking the mean of the two different values in each row
    alc[col_name] <- round(rowMeans(two_cols))
  #if the seleced column is not a number
    } else {
      #add the info from fist column to the new data frame alc.
    alc[col_name] <- first_col
  }
}

#check the new data
glimpse(alc)

#Add the alc_use column by counting how much alcohol is drank in weekend and weekdays
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

#add the high use column
alc <- mutate(alc, high_use = alc_use > 2)

#sneak peak of the data
glimpse(alc)

#Looks good! now it is time to safe it
write_csv(alc,"data/alc.csv")

#just double check
alc <- read.csv("data/alc.csv")
glimpse(alc)

#still good! :D