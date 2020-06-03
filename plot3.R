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
png(file = "plot3.png", width = 640, height = 480)
with(data, plot(datetime,sub_metering_1, type = "n", xlab = " ", ylab="Energy sub metering"))
with(data, lines(datetime,sub_metering_1, type="l", col = "black"))
with(data, lines(datetime,sub_metering_2, type="l", col = "red"))
with(data, lines(datetime,sub_metering_3, type="l", col = "blue"))
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=1, lwd=1, col=c("black", "red", "blue"))
dev.off()

