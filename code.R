
library(data.table)
library(tidyverse)
#library(lubridate)

d <- fread('gunzip -cq activity.zip')
# set date variable as date format
d$date <- as.Date(d$date)

#d[, month:= as.factor(month(d$date))]
#d[, day:= as.factor(day(d$date))]
#table(d$day)

#dl <- d[, sum(steps), by = day]
#ggplot(dl, aes(V1))+
#        geom_histogram()


sl <- d[, c(lapply(.SD, sum, na.rm = FALSE)), .SDcols = c("steps"), by = .(date)] 
ggplot(sl, aes(x = steps)) +
        geom_histogram(fill = "blue", binwidth = 1000)

(DailyStepsMean <- mean(sl$steps, na.rm = TRUE))
(DailyStepsMeadian <- median(sl$steps, na.rm = TRUE))

int <- d[, c(lapply(.SD, mean, na.rm = TRUE)), .SDcols = c("steps"), by = .(interval)] 
ggplot(int, aes(x = interval, y = steps)) +
        geom_line()

###############################################################
# check to see what proportion of the observations are missing
###############################################################
# count NA's in Steps variable
sum(is.na(d$steps)) / dim(d)[1]
# Compute percent of NA's in Steps variable
mean(is.na(d$steps))
# Compute percent of 0's in Steps variable
sum(d$steps == 0, na.rm = TRUE) / dim(d)[1]
mean(d$steps == 0, na.rm = TRUE) # this way, it computes mean without NA's, Change dimension.
sum(d$steps > 0, na.rm = TRUE)
# summary all variables of data set
summary(d)

# many plots
par(mfrow = c(1,3))
hist(d$steps)
hist(log10(d$steps))
plot(d$date, d$steps)

# 1st day
dia1 <- d[d$date == "2012-10-03",]
sum(dia1$steps, na.rm = TRUE)

table(month(d$date))
month(d$date[15000])
table(day(d$date))
sum(month(d$date)==10)
sum(month(d$date)==11)



