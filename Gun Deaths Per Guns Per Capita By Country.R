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
url3 = "https://raw.githubusercontent.com/ryantvackner/gun-deaths-by-country/main/population_by_country_2020.csv"
#read csv file from github
mydat = read.csv(url, header = TRUE)
mydat2 = read.csv(url2, header = TRUE)
mydat3 = read.csv(url3, header = TRUE)

# changing the name of the first colounm
colnames(mydat)[1] <- "country"
colnames(mydat2)[1] <- "country"
colnames(mydat3)[1] <- "country"

# merge dataframe
dftemp <- merge(mydat, mydat2, by = "country")
df <- merge(dftemp, mydat3, by = "country")
colnames(df)[8] <- "pop"
colnames(df)[11] <- "densitypkm"
colnames(df)[12] <- "landmasskm"
colnames(df)[16] <- "urban"
df$urban = as.numeric(df$urban)

# remove countrys with NaN
df[df == 0.0] <- NaN
df = na.omit(df)

# adding cols
df['firearmspercapita'] = df['per100']/100

# second df
# adjusting for the high rate of suicide by guns in the USA
df_suicide_adj = df
df_suicide_adj[158, 6] <- df_suicide_adj[158, 6]*.41
df_suicide_adj[158, 7] <- df_suicide_adj[158, 7]*.41


# find the magic number
df['firearmdeathsperfirearmspercapita'] = df['totalDeaths']/df['per100']
df_suicide_adj['firearmdeathsperfirearmspercapita'] = df_suicide_adj['totalDeaths']/df_suicide_adj['per100']

# plotting df
plot(x = df$per100, y = df$firearmdeathsperfirearmspercapita, xlab = "Firearms per 100k",
     ylab = "Firearm Deaths Per Firearms Per Capita",
     main = "Firearm Deaths Per Firearms Per Capita by County", type = "p", pch = 21, col = "blue", lwd = 2)

# plotting df_suicide_adj
plot(x = df_suicide_adj$per100, y = df_suicide_adj$firearmdeathsperfirearmspercapita, xlab = "Firearms per 100k",
     ylab = "Firearm Deaths Per Firearms Per Capita",
     main = "Firearm Deaths Per Firearms Per Capita by County", type = "p", pch = 21, col = "blue", lwd = 2)

# plotting df
plot(x = df$totalRate, y = df$firearmdeathsperfirearmspercapita, xlab = "Total Rate of Firearms Deaths per 100k",
     ylab = "Firearm Deaths Per Firearms Per Capita",
     main = "Firearm Deaths Per Firearms Per Capita by County", type = "p", pch = 21, col = "blue", lwd = 2)

# plotting df_suicide_adj
plot(x = df_suicide_adj$totalRate, y = df_suicide_adj$firearmdeathsperfirearmspercapita, xlab = "Total Rate of Firearms Deaths per 100k",
     ylab = "Firearm Deaths Per Firearms Per Capita",
     main = "Firearm Deaths Per Firearms Per Capita by County", type = "p", pch = 21, col = "blue", lwd = 2)


# regression
regdf = lm(totalDeaths~firearms, data = df)
summary(regdf)

reg2df = lm(totalDeaths~firearms + pop, data = df)
summary(reg2df)

reg3df = lm(totalDeaths~firearms + pop + urban, data = df)
summary(reg3df)

reg4df = lm(totalDeaths~firearms + pop + urban + landmasskm, data = df)
summary(reg4df)
