# Formats data as numeric to prevent scientific notation
NEI$Emissions <- as.numeric(NEI$Emissions)

# Takes subset for Baltimore only
baltEms <- NEI[which(NEI$fips == "24510"),]

# #Get total emissions per year
totalBalt <- aggregate(Emissions ~ year, baltEms, sum)

# Generate Graph
png("plot2.png", width=480, height=480)
barplot(totalBalt$Emissions, 
        names = totalBalt$year, 
        xlab = "Year", 
        ylab = "Emissions", 
        main = "Total PM2.5 Emissions in Baltimore City")
dev.off()