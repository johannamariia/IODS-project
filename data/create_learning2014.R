#Author: Johanna Lehtinen
#1.11.2023

#This is R code for Data Wrangling part of the IODS course assignment 2.


#Needed librarys
library(dplyr)
library(tidyverse)

#Reading in the data and safe it in new variable
data <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

#the dimensions of the data
dim(data) 
#There are 183 rows and 60 columns in the data e.g. 183 observations and 60 variables. 

#the structure of the data
str(data)
#Gender -column is in chr (character) mode and all the other columns are integers (aka numbers)

####create dataset for analysis#####

#we want to continue working with gender, age, attitude, deep, stra, surf and points

#column Attitude needs to be scaled so that it is in same format as other variables
data$attitude <- data$Attitude / 10

#Deep, stra, Surf are not yet in the dataset so we need to add them in.

#Create a list of questions that belong in different groups
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surf_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
stra_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

#Select wanted columns in the new variable
deep_columns <- select(data, one_of(deep_questions))
#create new column in the dataset based on selected columns
data$deep <- rowMeans(deep_columns)

#Select wanted columns in the new variable 
surf_columns <- select(data, one_of(surf_questions))
#create new column in the dataset based on selected columns
data$surf <- rowMeans(surf_columns)

#Select wanted columns in the new variable
stra_columns <- select(data, one_of(stra_questions))
#create new column in the dataset based on selected columns
data$stra <- rowMeans(stra_columns)

#now when all the columns are in the original data, make a subset of data that includes only wanted variables.First choose the wanted columns.
subset_columns <- c("gender","Age","attitude", "deep", "stra", "surf", "Points")

#select only predefined columns from the data
learning2014 <- select(data, one_of(subset_columns))

# see the structure of the new dataset
str(learning2014)

#Look what the column names are, and make the spelling similar
colnames(learning2014)

colnames(learning2014)[2] <- "age"
colnames(learning2014)[7] <- "points"

#Remove all the observations from people how did not attend the exam aka points = 0.
learning2014 <- filter(learning2014, points > 0)

#set working directory
setwd("Z:/Desktop/Opinnot/IODS/IODS-project")

#safe the final data to csv file.
write_csv(learning2014,"data/learning2014.csv")

#read the data again to check it
data_final <-  read_csv("data/learning2014.csv")

#structure of the data
str(data_final)

#first rows in the data
head(data_final)
