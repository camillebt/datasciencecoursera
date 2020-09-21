library("data.table")

#Reads in data from file then subsets data for specified dates
powerDataset <- data.table::fread(input = "household_power_consumption.txt", na.strings="?")

# Prevents Scientific Notation
powerDataset$Global_active_power <- as.numeric(powerDataset$Global_active_power)

# Separating time and date
powerDataset[, dateTime := as.POSIXct(paste(Date, Time), format = "%d/%m/%Y %H:%M:%S")]

# Filter dates
powerDataset <- powerDataset[(dateTime >= "2007-02-01") & (dateTime < "2007-02-03")]

png("plot2.png", width=480, height=480)

# Generates plot2
plot(x = powerDataset[, dateTime], y = powerDataset[, Global_active_power], type="l", xlab="", ylab="Global Active Power (kilowatts)")

dev.off()