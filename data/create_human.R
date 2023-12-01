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
human <-  read_csv("data/human.csv")

#structure of the data
str(human)

#first rows in the data
head(human)

#summary
summary(human)

#The data "Human" includes 195 rows and 19 columns. Included variables are:
#HDI.rank = Human development index ranking
#Country = character variable that indicates different countries on the data
#HDI2 = Human development index 
#Life.Exp = numeric variable that indicates Life Expectancy at Birth
#Edu.Exp = Numeric variable that indicates Expected Years of Education
#Edu.mean = Mean years of education, numeric value
#GNI = Gross National Income (GNI) per Capita, numeric variable
#GNI.minus.rank = Gross national income per capita minus the ranking
#GII.rank =  Gender Inequality Index ranking
#GII =  Gender Inequality Index
#Mat.Mor = Maternal Mortality Ratio, numeric variable
#Ado.Birth = Adolescent Birth Rate, numeric variable
#Parli.F = Percent Representation in Parliament, numeric variable
#Edu2.F = Population with Secondary Education (Female), numeric variable
#Edu2.M = Population with Secondary Education (Male), numeric variable
#Labo.F = Labour Force Participation Rate (Female), numeric variable
#Labo.M = Labour Force Participation Rate (Male), numeric variable
#Edu2.FM = ratio of female and male populations with secondary education in each country
#Labo.FM = ratio of labor force participation of females and males in each country

#define vector that includes only the important rows. 
keep <- c("Country", "Edu2.FM", "Labo.FM", "Life.Exp", "Edu.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")

#use select funktion to keep only previously defined columns
human <- dplyr::select(human, one_of(keep))

#remove all the NA values
human <- filter(human, complete.cases(human)) 

#check how many rows are not countries 
tail(human, 10)
#Niger is last country on the list so we want to remove all the rows under that.

# define the last row we want to keep
last <- nrow(human) - 7

# choose everything until the last 7 observations
human <- human[1:last, ]

#write the data again
write_csv(human,"data/human.csv")

#and final check that everything is correct. 
data_final <-  read_csv("data/human.csv")

#structure of the data
str(data_final)

#last rows in the data to see that there is only countries
tail(data_final,10)

#summary to see that there is no more NA values
summary(data_final)
