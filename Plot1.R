#Install packages if not already installed and load:

packages <- c("data.table", "dplyr", "tidyr", "lubridate")
for (i in packages) {
  if (is.na(match(i, rownames(installed.packages()))) == TRUE )  { 
    install.packages(i)
  }
}
lapply(packages, library, character.only = TRUE) 

#Set download URL's as variables

zipUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zipFile <- "ElectricPowerCons.zip"

# Download databases if didn't already and unzip them as well

if (!file.exists(zipFile)) {
  download.file(zipUrl, zipFile, mode = "wb")
}

dataPath <- "household_power_consumption.txt"
if (!file.exists(dataPath)) {
  unzip(zipFile)
}

#Read and process data

data <- fread("household_power_consumption.txt")
data <- filter(data, Date == "1/2/2007" | Date == "2/2/2007" )
data$Date <- dmy(data$Date)
data$Global_active_power <- as.numeric(data$Global_active_power)

#set grid just in case config is unset

par(mfrow = c(1,1))

#plot onto general device

hist(data$Global_active_power, col = "red", breaks = 24, xlab = "Global Active Power (kilowatts)", ylab = "Frequency", main = "Global Active Power")

#generate png file

png(filename = "plot1.png")

hist(data$Global_active_power, col = "red", breaks = 24, xlab = "Global Active Power (kilowatts)", ylab = "Frequency", main = "Global Active Power")

dev.off()