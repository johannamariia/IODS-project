library(tidyverse)
library(readr)
hd <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human_development.csv")
gii <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/gender_inequality.csv", na = "..")

#structure of the data
str(hd)
str(gii)

#Dimensions of the data
dim(hd)
dim(gii)

#summary of the variables
summary(hd)
summary(gii)

#rename columns
hd <- hd %>% 
  rename("GNI" = "Gross National Income (GNI) per Capita",
         "Life.Exp" = "Life Expectancy at Birth",
         "Edu.Exp" = "Expected Years of Education",
         "HDI.rank" = "HDI Rank",
         "HDI2 "= "Human Development Index (HDI)",
         "GNI.minus.rank" = "GNI per Capita Rank Minus HDI Rank",
         "Edu.mean" = "Mean Years of Education")

gii <- gii %>% 
  rename("Mat.Mor" = "Maternal Mortality Ratio",
         "Ado.Birth" = "Adolescent Birth Rate",
         "Parli.F" = "Percent Representation in Parliament",
         "Edu2.F" = "Population with Secondary Education (Female)",
         "Edu2.M" = "Population with Secondary Education (Male)",
         "Labo.F" = "Labour Force Participation Rate (Female)",
         "Labo.M" = "Labour Force Participation Rate (Male)",
         "GII.rank" = "GII Rank",
         "GII" = "Gender Inequality Index (GII)")

#i was unsure about was i suppose to change only the names in meta file or all of them, so i changed them all. 

#Add the new variables in the data
gii$Edu2.FM <- gii$Edu2.F/gii$Edu2.M
gii$Labo.FM <-  gii$Labo.F/gii$Labo.M

#Combine the data into variable human. Because the country is only column in both data sets the inner join will automatically use that as a combining column. 
human <- hd %>%
  inner_join(gii)

#safe the new data into new file
write_csv(human,"data/human.csv")

#read the data again to check it
data_final <-  read_csv("data/human.csv")

#structure of the data
str(data_final)

#first rows in the data
head(data_final)

