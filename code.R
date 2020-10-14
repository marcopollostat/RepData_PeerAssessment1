
library(data.table)
library(tidyverse)


d <- fread('gunzip -cq activity.zip')
# set date variable as date format
d$date <- as.Date(d$date)

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

d[is.na(steps), "steps"] <- d[, c(lapply(.SD, mean, na.rm = TRUE)), .SDcols = c("steps")]







