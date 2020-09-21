library("data.table")

# Reads data
powerDataset <- data.table::fread(input = "household_power_consumption.txt", na.strings="?")

# Formats values to numeric to prevent scientific notation
powerDataset$Global_active_power <- as.numeric(powerDataset$Global_active_power)

# Formats date columns to make it easier to filter
powerDataset$Date <- as.Date(powerDataset$Date, format="%d/%m/%Y")

# Filter dates
powerDataset <- powerDataset[(Date >= "2007-02-01") & (Date <= "2007-02-02")]

png("plot1.png", width=480, height=480)

# Generates plot1
hist(powerDataset[, Global_active_power], main="Global Active Power", xlab="Global Active Power (kilowatts)", ylab="Frequency", col="Red")

dev.off()
