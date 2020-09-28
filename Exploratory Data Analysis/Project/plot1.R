# Read RDS files

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Formats data as numeric to prevent scientific notation
NEI$Emissions <- as.numeric(NEI$Emissions)

# Get total emissions regardless of state
totalEms <- aggregate(Emissions ~ year, NEI, sum)

# Generate Graph
png("plot1.png", width=480, height=480)
barplot(totalEms$Emissions/10^6, 
        names = totalEms$year, 
        xlab = "Year", 
        ylab = "Emissions in Mio", 
        main = "Total PM2.5 Emissions in the US")
dev.off()