
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



# Just recreating activityDT from scratch then making the new factor variable. (No need to, just want to be clear on what the entire process is.) 
d <- data.table::fread(input = "data/activity.csv")
d[, date := as.POSIXct(date, format = "%Y-%m-%d")]

d[, `Day of Week`:= weekdays(x = date)]
d[grepl(pattern = "Monday|Tuesday|Wednesday|Thursday|Friday", x = `Day of Week`), "weekday or weekend"] <- "weekday"
d[grepl(pattern = "Saturday|Sunday", x = `Day of Week`), "weekday or weekend"] <- "weekend"
d[, `weekday or weekend` := as.factor(`weekday or weekend`)]
head(d, 10)



d[is.na(steps), "steps"] <- d[, c(lapply(.SD, median, na.rm = TRUE)), .SDcols = c("steps")]
IntervalDT <- activityDT[, c(lapply(.SD, mean, na.rm = TRUE)), .SDcols = c("steps"), by = .(interval, `weekday or weekend`)] 
ggplot(IntervalDT , aes(x = interval , y = steps, color=`weekday or weekend`)) + geom_line() + labs(title = "Avg. Daily Steps by Weektype", x = "Interval", y = "No. of Steps") + facet_wrap(~`weekday or weekend` , ncol = 1, nrow=2)




