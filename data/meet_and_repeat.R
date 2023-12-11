## R - code for Data wrangling part of the assigment 6 

#libraries
library(tidyverse)

#read in the data
RATS <- read.table('https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt')
BPRS <- read.table('https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt', header = T)

#Structure of data
str(RATS)
str(BPRS)

#Dimensions
dim(RATS)
dim(BPRS)

#Summaries
summary(RATS)
summary(BPRS)

#Change categorical varianles to factors

#RATS

RATS$Group <- as.factor(RATS$Group)
RATS$ID <- as.factor(RATS$ID)
#check the results
str(RATS)

#BPRS
BPRS$treatment <- as.factor(BPRS$treatment)
BPRS$subject <- as.factor(BPRS$subject)
#check the results
str(BPRS)


#convert data to long form
BPRS <-  pivot_longer(BPRS, cols = -c(treatment, subject),
                       names_to = "weeks", values_to = "bprs") %>%
  arrange(weeks)

# Add the week variable
BPRS <-  BPRS %>% 
  mutate(week = as.integer(substr(weeks,5,5)))

#Change the RATS variable to long form and add the time object
RATS <- pivot_longer(RATS, cols=-c(ID,Group), names_to = "WD",values_to = "Weight")  %>%  
  mutate(Time = as.integer(substr(WD,3,4))) %>% 
  arrange(Time)

#Check how the new longer versions of the data looks
str(BPRS)
dim(BPRS)
summary(BPRS)
#In the original data there was 11 variables and 40 observations and now there is 5 variables and 360 observations (so every observation in original 9 week columns is now in same column aka 40*9 = 360). In the wide form, all the weeks where in their own 
#column, but now all the weeks are in one column. Week numbers are in column week and the values are in the bprs column. Other columns are treatment (ether 1 or 2), and subject (value from 1 to 20). 
#There is also column weeks that includes the original column names for different weeks.

str(RATS)
dim(RATS)
summary(RATS)
#Rats has the same thing as BPRS data. So all the values in the original WD -columns are now in one column called Weight Also there is information about original column name in WD column.

#Safe the new datasets

#BPRS
write_csv(BPRS,"data/BPRS.csv")

#RATS
write_csv(RATS,"data/RATS.csv")
