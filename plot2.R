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
png(file = "plot2.png", width = 640, height = 480)
plot(data$datetime, data$global_active_power, type="l", xlab="", ylab="Global Active Power (kilowatts)")
dev.off()
