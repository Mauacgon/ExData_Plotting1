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
data$Sub_metering_1 <- as.numeric(data$Sub_metering_1)
data$Sub_metering_2 <- as.numeric(data$Sub_metering_2)
data$Sub_metering_3 <- as.numeric(data$Sub_metering_3)
data <- mutate(data, Weekday = weekdays(Date, abbreviate = TRUE))

#Generate auxiliar variable with obs numbers for x axis values

data <- mutate(data, obsn = seq_along(data$Date))

#Set grid just in case is unset

par(mfrow = c(1,1))

#Plot onto general device

plot(data$obsn, data$Sub_metering_1, type = "n", xaxt = "n", xlab = "", ylab = "Energy Sub Metering")
axis(1, at = c(0, mean(data$obsn), max(data$obsn)), labels = c("Thu", "Fri", "Sat"))
lines(data$obsn, data$Sub_metering_1, col = "black")
lines(data$obsn, data$Sub_metering_2, col = "red")
lines(data$obsn, data$Sub_metering_3, col = "blue")
legend("topright", legend = c("Sub_Metering1", "Sub_Metering2", "Sub_Metering3"), col = c("black", "red", "blue"), lty = 1)

#create png file

png(filename = "plot3.png")

plot(data$obsn, data$Sub_metering_1, type = "n", xaxt = "n", xlab = "", ylab = "Energy Sub Metering")
axis(1, at = c(0, mean(data$obsn), max(data$obsn)), labels = c("Thu", "Fri", "Sat"))
lines(data$obsn, data$Sub_metering_1, col = "black")
lines(data$obsn, data$Sub_metering_2, col = "red")
lines(data$obsn, data$Sub_metering_3, col = "blue")
legend("topright", legend = c("Sub_Metering1", "Sub_Metering2", "Sub_Metering3"), col = c("black", "red", "blue"), lty = 1)

dev.off()

