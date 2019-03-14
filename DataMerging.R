# Setting working space
if(Sys.info()["user"] == "norzvic"){
  setwd("/Users/norzvic/Dropbox/UCSD/18-19/02 Winter/SOCG290 Big Data/Project")
  options(digits=3)
}

# Loading packages
library(openxlsx)
library(xlsx)

# Merge dataframes
data.hiphop2017 <- read.xlsx("sample_hiphop_2017_clean.xlsx", sheetName = "Sheet1", colNames = T)
data.hiphop2018 <- read.xlsx("sample_hiphop_2018_clean.xlsx", sheetName = "Sheet1", colNames = T)
data.hiphop <- rbind(data.hiphop2017, data.hiphop2018)
data.hiphop$class <- "hiphop"

data.pop2017 <- read.xlsx("sample_pop_2017_clean.xlsx", sheetName = "Sheet1", colNames = T)
data.pop2018.1 <- read.xlsx("sample_pop_2018_1_clean.xlsx", sheetName = "Sheet1", colNames = T)
data.pop2018.2 <- read.xlsx("sample_pop_2018_2_clean.xlsx", sheetName = "Sheet1", colNames = T)
data.pop <- rbind(data.pop2017, data.pop2018.1, data.pop2018.2)
data.pop$class <- "pop"

data.rock2017 <- read.xlsx("sample_rock_2017_clean.xlsx", sheetName = "Sheet1", colNames = T)
data.rock2018 <- read.xlsx("sample_rock_2018_clean.xlsx", sheetName = "Sheet1", colNames = T)
data.rock <- rbind(data.rock2017, data.rock2018)
data.rock$class <- "rock"

data <- rbind(data.hiphop, data.pop, data.rock)
write.csv(data, "sample_xiami_scraping.csv")
write.xlsx(data, "sample_xiami_scraping.xlsx")

# Loading processed songs' data
#data <- read.xlsx("sample_xiami_scraping.xlsx", sheetName = "Sheet1", colNames = T)
data.librosa <- read.xlsx("data_xiami_labelprobs_utf8.xlsx", sheetName = "Sheet2" ,colNames = T)
songname <- data["song_name"]
songname <- gsub("（.*）", "", songname[,1])
songname <- gsub(" ", "", songname)
songname <- gsub("\\.", "", songname)

songname.librosa <- data.librosa["filename"]
bbb.12 <- gsub(".*-\\s(.*)\\s.mp3$", "\\1",songname.librosa)

songname.librosa <- gsub(".mp3$", "", songname.librosa[,1])
songname.librosa <- gsub(".*-", "", songname.librosa)
songname.librosa <- gsub(",", "", songname.librosa)
songname.librosa <- gsub("\\s*\\([^\\)]+\\)", "", songname.librosa)
songname.librosa <- gsub("'", "", songname.librosa)
songname.librosa <- gsub("－", "", songname.librosa)
songname.librosa <- gsub("【.*】", "", songname.librosa)
songname.librosa <- gsub("·", "", songname.librosa)
songname.librosa <- gsub("｜", "", songname.librosa)
songname.librosa <- gsub("，", "", songname.librosa)
songname.librosa <- gsub(".wav$", "", songname.librosa)
songname.librosa <- gsub("、", "", songname.librosa)


sn <- cbind(songname, songname.librosa)
write.xlsx(sn, "sncheck.xlsx")

for i in length(nrow(songname)){
  for j in length(nrow(songname.librosa)){
    if songname.librosa[j] 
  }
}

