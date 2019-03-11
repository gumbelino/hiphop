# Setting working space
if(Sys.info()["user"] == "norzvic"){
  setwd("/Users/norzvic/Dropbox/UCSD/18-19/02 Winter/SOCG290 Big Data/Project")
  options(digits=3)
}

# Loading packages
library(openxlsx)
library(xlsx)

# Merge dataframes
data.hiphop2017 <- read.xlsx("sample_hiphop_2017_clean.xlsx", colNames = T)
data.hiphop2018 <- read.xlsx("sample_hiphop_2018_clean.xlsx", colNames = T)
data.hiphop <- rbind(data.hiphop2017, data.hiphop2018)
data.hiphop$class <- "hiphop"

data.pop2017 <- read.xlsx("sample_pop_2017_clean.xlsx", colNames = T)
data.pop2018.1 <- read.xlsx("sample_pop_2018_1_clean.xlsx", colNames = T)
data.pop2018.2 <- read.xlsx("sample_pop_2018_2_clean.xlsx", colNames = T)
data.pop <- rbind(data.pop2017, data.pop2018.1, data.pop2018.2)
data.pop$class <- "pop"

data.rock2017 <- read.xlsx("sample_rock_2017_clean.xlsx", colNames = T)
data.rock2018 <- read.xlsx("sample_rock_2018_clean.xlsx", colNames = T)
data.rock <- rbind(data.rock2017, data.rock2018)
data.rock$class <- "rock"

data <- rbind(data.hiphop, data.pop, data.rock)
write.csv(data, "sample_xiami_scraping.csv")
write.xlsx(data, "sample_xiami_scraping.xlsx")

