library("data.table")

# Reads data
powerDataset <- data.table::fread(input = "household_power_consumption.txt", na.strings="?")

# Formats values to numeric to prevent scientific notation
powerDataset$Global_active_power <- as.numeric(powerDataset$Global_active_power)

# Separating time and date
powerDataset[, dateTime := as.POSIXct(paste(Date, Time), format = "%d/%m/%Y %H:%M:%S")]

# Filter dates
powerDataset <- powerDataset[(dateTime >= "2007-02-01") & (dateTime < "2007-02-03")]

png("plot3.png", width=480, height=480)

# Generates plot3
plot(powerDataset[, dateTime], powerDataset[, Sub_metering_1], type="l", xlab="", ylab="Energy sub metering")
lines(powerDataset[, dateTime], powerDataset[, Sub_metering_2],col="red")
lines(powerDataset[, dateTime], powerDataset[, Sub_metering_3],col="blue")
legend("topright", col=c("black","red","blue"), c("Sub_metering_1  ","Sub_metering_2  ", "Sub_metering_3  "),lty=c(1,1), lwd=c(1,1))

dev.off()