# Setting working space
if(Sys.info()["user"] == "norzvic"){
  setwd("/Users/norzvic/Dropbox/UCSD/18-19/02 Winter/SOCG290 Big Data/Project")
  options(digits=3)
}

# Loading packages
library(xlsx)
library(tidyverse)
library(scales)

# Loading data
read <- read.xlsx("results_clean_working.xlsx", sheetName = "Sheet1", colNames = T)
data <- read[, 2:48]
data$release_month <- gsub("\\.[0-9][0-9]$", "", data[, "release_date"])
#data$release_month <- gsub("\\.", "", data[, "release_month"])
#data$release_month <- as.numeric(data$release_month)
#data$release_date <- gsub("\\.", "", data[, "release_date"])
#data$release_date <- as.numeric(data$release_date)

# Check data
# Check change of hiphopiness
ggplot(data, aes(x = as.numeric(release_date), y = hiphopiness, color = class)) +
  geom_point() +
  geom_vline(aes(xintercept = as.numeric(release_date[692])), size = 1, linetype = "dashed", color = "black") +
  geom_smooth(method = "loess", formula = y ~ x, se = T) +
  labs(title="Hip-Hopiness of Songs Released 2017-2018, Divided by Genre", x="Release Date", y="Hip-Hopiness") +
  scale_x_continuous() +
  scale_colour_manual(name='Genre', values=c('hiphop'='tomato', 'pop'='steelblue', 'rock'='olivedrab', 'folk'='seagreen'))

# Check change of speechiness
ggplot(data, aes(x = as.numeric(release_date), y = speechiness, colour = class)) +
  geom_point() +
  geom_vline(aes(xintercept = as.numeric(release_date[692])), size = 1, linetype = "dashed", color = "black") +
  geom_smooth(method = "loess", formula = y ~ x, se = T) +
  labs(title="Speechiness of Songs Released 2017-2018, Divided by Genre", x="Release Date", y="Speechiness") +
  scale_x_continuous() +
  scale_colour_manual(name='Genre', values=c('hiphop'='tomato', 'pop'='steelblue', 'rock'='olivedrab', 'folk'='seagreen'))

# Setting up the data
data$treatment <- NA
data$treatment[which(as.numeric(data$release_date) < as.numeric(data$release_date[692]))] <- 0
data$treatment[which(as.numeric(data$release_date) >= as.numeric(data$release_date[692]))] <- 1

data$month_trend <- NA
for (i in 1:nrow(data)){
  ddd <- as.integer(sub("\\.", "", data[i, "release_month"])) - 201801
  if (ddd >= 0){
    data$month_trend[i] <- ddd
  } else{
    data$month_trend[i] <- ddd + 88
  }
} # time trends

# Modeling
lm.hiphopiness <- lm(hiphopiness ~ treatment + month_trend + factor(release_month) + factor(class), data = data)
lm.hiphopiness.simple <- lm(hiphopiness ~ treatment + factor(release_month) + factor(class), data = data)
lm.speechiness <- lm(speechiness ~ treatment + month_trend + factor(release_month) + factor(class), data = data)
lm.speechiness.simple <- lm(speechiness ~ treatment + factor(release_month) + factor(class), data = data)

# DID
# Hiphop vs rock
data.hiprock <- rbind(data[which(data$class == "hiphop"),], data[which(data$class == "rock"),])
data.hiprock$hiphop <- NA
data.hiprock$hiphop[which(data.hiprock$class == "hiphop")] <- 1
data.hiprock$hiphop[which(data.hiprock$class == "rock")] <- 0
did.hiphopiness.hiprock <- lm(hiphopiness ~ treatment * hiphop + month_trend, data = data.hiprock)
did.speechiness.hiprock <- lm(speechiness ~ treatment * hiphop + month_trend, data = data.hiprock)

# Hiphop vs pop
data.hippop <- rbind(data[which(data$class == "hiphop"),], data[which(data$class == "pop"),])
data.hippop$hiphop <- NA
data.hippop$hiphop[which(data.hippop$class == "hiphop")] <- 1
data.hippop$hiphop[which(data.hippop$class == "pop")] <- 0
did.hiphopiness.hippop <- lm(hiphopiness ~ treatment * hiphop + month_trend, data = data.hippop)
did.speechiness.hippop <- lm(speechiness ~ treatment * hiphop + month_trend, data = data.hippop)

# Hiphop vs folk
data.hipfolk <- rbind(data[which(data$class == "hiphop"),], data[which(data$class == "folk"),])
data.hipfolk$hiphop <- NA
data.hipfolk$hiphop[which(data.hipfolk$class == "hiphop")] <- 1
data.hipfolk$hiphop[which(data.hipfolk$class == "folk")] <- 0
did.hiphopiness.hipfolk <- lm(hiphopiness ~ treatment * hiphop, data = data.hipfolk)
did.speechiness.hipfolk <- lm(speechiness ~ treatment * hiphop, data = data.hipfolk)

# Pop vs rock
data.poprock <- rbind(data[which(data$class == "pop"),], data[which(data$class == "rock"),])
data.poprock$pop <- NA
data.poprock$pop[which(data.poprock$class == "pop")] <- 1
data.poprock$pop[which(data.poprock$class == "rock")] <- 0
did.hiphopiness.poprock <- lm(hiphopiness ~ treatment * pop + month_trend, data = data.poprock)
did.speechiness.poprock <- lm(speechiness ~ treatment * pop + month_trend, data = data.poprock)

# Visualization
# Whole
ggplot(data, aes(x = month_trend, y = hiphopiness, 
                 color = factor(treatment, labels = c('before', 'after')))) +
  #labs(title='The naturalization rate in Aarberg (0 = Year 2000)', 
  #    y = 'Naturalization rate',
  #   x = 'Time trend') +
  geom_point(aes(shape = class), size = 2) +
  scale_color_brewer(NULL, type = 'qual', palette = 6) + 
  geom_vline(aes(xintercept = 0), color = 'grey', size = 1, linetype = 'dashed') + 
  stat_smooth(method = 'loess', formula = y ~ x) +
  labs(title="Effect of Censorship on Hip-Hopiness", x="Time to censorship", y="Hip-Hopiness")

ggplot(data, aes(x = month_trend, y = speechiness, 
                 color = factor(treatment, labels = c('before', 'after')))) +
  #labs(title='The naturalization rate in Aarberg (0 = Year 2000)', 
  #    y = 'Naturalization rate',
  #   x = 'Time trend') +
  geom_point(aes(shape = class), size = 2) +
  scale_color_brewer(NULL, type = 'qual', palette = 6) + 
  geom_vline(aes(xintercept = 0), color = 'grey', size = 1, linetype = 'dashed') + 
  stat_smooth(method = 'loess', formula = y ~ x) +
  labs(title="Effect of Censorship on Speechiness", x="Time to censorship", y="Speechiness")


# Individual genre
ggplot(data[which(data$class == "hiphop"),], aes(x = month_trend, y = hiphopiness, 
                                               color = factor(treatment, labels = c('before', 'after')))) +
  #labs(title='The naturalization rate in Aarberg (0 = Year 2000)', 
   #    y = 'Naturalization rate',
    #   x = 'Time trend') +
  geom_point() +
  scale_color_brewer(NULL, type = 'qual', palette = 6) + 
  geom_vline(aes(xintercept = 0), color = 'grey', size = 1, linetype = 'dashed') + 
  stat_smooth(method = 'lm', formula = y ~ x)
  #stat_smooth(method = 'lm', formula = y ~ x + I(x^2))
  #stat_smooth(method = 'lm', formula = y ~ x + I(x^2) + factor(x))


ggplot(data[which(data$class == "pop"),], aes(x = month_trend, y = hiphopiness, 
                                                 color = factor(treatment, labels = c('before', 'after')))) +
  #labs(title='The naturalization rate in Aarberg (0 = Year 2000)', 
  #    y = 'Naturalization rate',
  #   x = 'Time trend') +
  geom_point() +
  scale_color_brewer(NULL, type = 'qual', palette = 6) + 
  geom_vline(aes(xintercept = 0), color = 'grey', size = 1, linetype = 'dashed') + 
  stat_smooth(method = 'lm', formula = y ~ x) +
  stat_smooth(method = 'lm', formula = y ~ x + I(x^2)) + 
  stat_smooth(method = 'lm', formula = y ~ x + I(x^2) + factor(x))

ggplot(data[which(data$class == "rock"),], aes(x = month_trend, y = hiphopiness, 
                                              color = factor(treatment, labels = c('before', 'after')))) +
  #labs(title='The naturalization rate in Aarberg (0 = Year 2000)', 
  #    y = 'Naturalization rate',
  #   x = 'Time trend') +
  geom_point() +
  scale_color_brewer(NULL, type = 'qual', palette = 6) + 
  geom_vline(aes(xintercept = 0), color = 'grey', size = 1, linetype = 'dashed') + 
  stat_smooth(method = 'lm', formula = y ~ x) +
  stat_smooth(method = 'lm', formula = y ~ x + I(x^2)) + 
  stat_smooth(method = 'lm', formula = y ~ x + I(x^2) + factor(x))




# Graphic across class
ggplot(data = data.hippop, aes(x = month_trend, y = hiphopiness, 
                               color = factor(treatment, labels = c('before', 'after')),
                               shape = class)) +
  #labs(title='The naturalization rate in Aarberg (0 = Year 2000)', 
  #    y = 'Naturalization rate',
  #   x = 'Time trend') +
  geom_point() +
  scale_color_brewer(NULL, type = 'qual', palette = 6) + 
  geom_vline(aes(xintercept = 0), color = 'grey', size = 1, linetype = 'dashed') + 
  stat_smooth(method = 'lm', formula = y ~ x) +
  labs(title="Effect of Censorship on Hip-Hopiness, Hip-Hop vs Pop", x="Time to censorship", y="Hip-Hopiness")


ggplot(data = data.hiprock, aes(x = month_trend, y = hiphopiness, 
                               color = factor(treatment, labels = c('before', 'after')),
                               shape = class)) +
  #labs(title='The naturalization rate in Aarberg (0 = Year 2000)', 
  #    y = 'Naturalization rate',
  #   x = 'Time trend') +
  geom_point() +
  scale_color_brewer(NULL, type = 'qual', palette = 6) + 
  geom_vline(aes(xintercept = 0), color = 'grey', size = 1, linetype = 'dashed') + 
  stat_smooth(method = 'lm', formula = y ~ x) +
  labs(title="Effect of Censorship on Hip-Hopiness, Hip-Hop vs Rock", x="Time to censorship", y="Hip-Hopiness")


ggplot(data = data.hipfolk, aes(x = month_trend, y = hiphopiness, 
                                color = factor(treatment, labels = c('before', 'after')),
                                shape = class)) +
  #labs(title='The naturalization rate in Aarberg (0 = Year 2000)', 
  #    y = 'Naturalization rate',
  #   x = 'Time trend') +
  geom_point() +
  scale_color_brewer(NULL, type = 'qual', palette = 6) + 
  geom_vline(aes(xintercept = 0), color = 'grey', size = 1, linetype = 'dashed') + 
  stat_smooth(method = 'lm', formula = y ~ x) +
  labs(title="Effect of Censorship on Hip-Hopiness, Hip-Hop vs Folk", x="Time to censorship", y="Hip-Hopiness")

ggplot(data = data, aes(x = month_trend, y = hiphopiness, 
                                color = factor(treatment, labels = c('before', 'after')),
                                shape = class)) +
  #labs(title='The naturalization rate in Aarberg (0 = Year 2000)', 
  #    y = 'Naturalization rate',
  #   x = 'Time trend') +
  geom_point() +
  scale_color_brewer(NULL, type = 'qual', palette = 6) + 
  geom_vline(aes(xintercept = 0), color = 'grey', size = 1, linetype = 'dashed') + 
  stat_smooth(method = 'lm', formula = y ~ x) +
  labs(title="Effect of Censorship on Hip-Hopiness, Across Genre", x="Time to censorship", y="Hip-Hopiness")

# Test on smaller window
data.small <- data[which(data$month_trend >= -3 & data$month_trend <= 3),] 

ggplot(data = data.small, aes(x = month_trend, y = hiphopiness, 
                        color = factor(treatment, labels = c('before', 'after')),
                        shape = class)) +
  #labs(title='The naturalization rate in Aarberg (0 = Year 2000)', 
  #    y = 'Naturalization rate',
  #   x = 'Time trend') +
  geom_point() +
  scale_color_brewer(NULL, type = 'qual', palette = 6) + 
  geom_vline(aes(xintercept = 0), color = 'grey', size = 1, linetype = 'dashed') + 
  stat_smooth(method = 'lm', formula = y ~ x) +
  labs(title="Effect of Censorship on Hip-Hopiness, Smaller Window", x="Time to censorship", y="Hip-Hopiness")





