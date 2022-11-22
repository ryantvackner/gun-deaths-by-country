##*
##*Gun Deaths Per Guns Per Capita By Country
##*Ryan Vackner 
##*November 21st, 2022
##*
##*
library(readr)
library(stargazer)
library(jtools)
library(ggplot2)
library(RCurl)

#url of the csv file
url = "https://raw.githubusercontent.com/ryantvackner/gun-deaths-by-country/main/Gun%20Ownership%20by%20Country%202022.csv"
url2 = "https://raw.githubusercontent.com/ryantvackner/gun-deaths-by-country/main/Gun%20Deaths%20by%20Country%202022.csv"

#read csv file from github
mydat = read.csv(url, header = TRUE)
mydat2 = read.csv(url, header = TRUE)

# changing the name of the first colounm
colnames(mydat)[1] <- "country"
colnames(mydat2)[1] <- "country"

# merge dataframe
df <- merge(mydat, mydat2, by = "country")