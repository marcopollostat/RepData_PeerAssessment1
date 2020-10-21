
rm(list = ls())

library(data.table)
library(tidyverse)

unzip("activity.zip")
d <- fread('activity.csv')
str(d)
d$date <- as.Date(d$date)
str(d)

sl <- d[, c(lapply(.SD, sum, na.rm = FALSE)), .SDcols = c("steps"), by = .(date)] 
ggplot(sl, aes(x = steps)) +
        geom_histogram(fill = "blue", binwidth = 1000)

(DailyStepsMean <- mean(sl$steps, na.rm = TRUE))
(DailyStepsMeadian <- median(sl$steps, na.rm = TRUE))

int <- d[, c(lapply(.SD, mean, na.rm = TRUE)), .SDcols = c("steps"), by = .(interval)] 
ggplot(int, aes(x = interval, y = steps)) +
        geom_line()

int[which.max(int$steps), 1]

sum(is.na(d$steps))

d[is.na(steps), "steps"] <- d[, c(lapply(.SD, median, na.rm = TRUE)), .SDcols = c("steps")]

data.table::fwrite(x = d, file = "tidyData.csv", quote = FALSE)
#a <- read_csv("tidyData.csv")
#summary(a); str(a)

totalSteps <- d[, c(lapply(.SD, sum)), .SDcols = c("steps"), by = .(date)] 

totalSteps[, .(Mean_Steps = mean(steps), Median_Steps = median(steps))]





