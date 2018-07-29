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
data <- mutate(data, Weekday = weekdays(Date, abbreviate = TRUE))

#Create auxiliar variable with obs number for x axis

data <- mutate(data, obsn = seq_along(data$Date))

#Set grid just in case is unset

par(mfrow = c(1,1))

#Plot onto general device

plot(data$obsn, data$Global_active_power, type = "l", xaxt = "n", xlab = "", ylab = "Global Active Power (kilowatts)")
axis(1, at = c(0, mean(data$obsn), max(data$obsn)), labels = c("Thu", "Fri", "Sat"))

#Create png file

png(filename = "plot2.png")

plot(data$obsn, data$Global_active_power, type = "l", xaxt = "n", xlab = "", ylab = "Global Active Power (kilowatts)")
axis(1, at = c(0, mean(data$obsn), max(data$obsn)), labels = c("Thu", "Fri", "Sat"))

dev.off()