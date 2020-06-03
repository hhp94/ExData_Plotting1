# Load Library
library(tidyverse)
library(data.table)
library(janitor)
library(lubridate)

# Download
url_1<- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url_1, destfile = "./household_power_consumption.zip", method = "curl")
unzip(zipfile = "./household_power_consumption.zip", files = "./household_power_consumption.txt")

data<-fread("./household_power_consumption.txt") %>% 
        as_tibble %>%
        clean_names

# Cleanup data 
data <- data %>% mutate(date = dmy(data$date)) %>%
        mutate(time = hms(data$time)) %>%
        mutate(across(global_active_power:sub_metering_3, as.numeric)) %>% 
        filter((date >= "2007-02-01" & date <= "2007-02-02"))

#Merge Date and Time
datetime<-with(data, date + time)
data <- data %>% mutate(datetime = datetime)

#Plotting:

png(file = "plot4.png", width = 1024, height = 720)
par(mfrow=c(2,2))

plot(data$datetime, data$global_active_power, type="l", xlab="", ylab="Global Active Power (kilowatts)")        #1st plot

with(data, plot(datetime,voltage, xlab = "datetime", ylab = "Voltage", type = "l"))                             #2nd plot

with(data, plot(datetime,sub_metering_1, type = "n", xlab = " ", ylab="Energy sub metering"))                   #3rd plot
with(data, lines(datetime,sub_metering_1, type="l", col = "black"))
with(data, lines(datetime,sub_metering_2, type="l", col = "red"))
with(data, lines(datetime,sub_metering_3, type="l", col = "blue"))
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=1, lwd=2, col=c("black", "red", "blue"))

with(data, plot(datetime,global_reactive_power, xlab = "datetime", ylab = "Global_reactive_power", type = "l")) #4th plot

dev.off()

