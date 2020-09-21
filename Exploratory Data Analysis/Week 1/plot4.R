library("data.table")

# Reads data
powerDataset <- data.table::fread(input = "household_power_consumption.txt", na.strings="?")

# Formats values to numeric to prevent scientific notation
powerDataset$Global_active_power <- as.numeric(powerDataset$Global_active_power)

# Separating time and date
powerDataset[, dateTime := as.POSIXct(paste(Date, Time), format = "%d/%m/%Y %H:%M:%S")]

# Filter dates
powerDataset <- powerDataset[(dateTime >= "2007-02-01") & (dateTime < "2007-02-03")]

png("plot4.png", width=480, height=480)

par(mfrow=c(2,2))

# Generate plot 1
plot(powerDataset[, dateTime], powerDataset[, Global_active_power], type="l", xlab="", ylab="Global Active Power")

# Generate plot 2
plot(powerDataset[, dateTime],powerDataset[, Voltage], type="l", xlab="datetime", ylab="Voltage")

# Generate plot 3
plot(powerDataset[, dateTime], powerDataset[, Sub_metering_1], type="l", xlab="", ylab="Energy sub metering")
lines(powerDataset[, dateTime], powerDataset[, Sub_metering_2], col="red")
lines(powerDataset[, dateTime], powerDataset[, Sub_metering_3],col="blue")
legend("topright", col=c("black","red","blue"), c("Sub_metering_1  ","Sub_metering_2  ", "Sub_metering_3  "), lty=c(1,1), bty="n", cex=.5) 

# Generate plot 4
plot(powerDataset[, dateTime], powerDataset[,Global_reactive_power], type="l", xlab="datetime", ylab="Global_reactive_power")

dev.off()