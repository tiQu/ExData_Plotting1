## 0. Downloads and unzips file within data directory
if (!file.exists("data")) {
        dir.create("data")
}

### 0.a installs data.table and lubridate packages if necessary
if("data.table" %in% rownames(installed.packages()) == F) {install.packages("data.table")}
if("lubridate" %in% rownames(installed.packages()) == F) {install.packages("lubridate")}

fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl, destfile = "./data/HouseholdPowerConsumption.zip", method = "curl")

unzip("./data/HouseholdPowerConsumption.zip",exdir="./data/")

dateDownloaded <- date()

## 1. Reading and formatting data
# 1.a Reading and subsetting the total data
total <- data.table::fread("./data/household_power_consumption.txt",sep = ";",na.strings = "?",header = T)
total$Date <- as.character(total$Date)
power_data <- total[total$Date=="1/2/2007" | total$Date=="2/2/2007",]

# 1.b Reformatting the Date / Time variables into a readable format (they were still factors at this point)
power_data$datetime <- paste(as.character(power_data$Date),as.character(power_data$Time))
power_data$datetime <- lubridate::dmy_hms(power_data$datetime, tz="GMT")
power_data$datetime <- as.POSIXct(strptime(power_data$datetime, "%Y-%m-%d %H:%M:%S"))

## 2. Creating Plot 3
png(filename = "plot3.png", width = 480, height = 480)
plot(power_data$datetime, power_data$Sub_metering_1, pch=".",
     ylab = "Energy sub metering",
     xlab = "")
lines(power_data$datetime, power_data$Sub_metering_1, pch=".")
lines(power_data$datetime, power_data$Sub_metering_2, pch=".", col="red")
lines(power_data$datetime, power_data$Sub_metering_3, pch=".", col="blue")
legend("topright", legend = names(power_data)[7:9], col = c("black","red","blue"), pch = "—")
dev.off()