# Find car related in SCC and link back to NEI
vehicleRel <- grepl("vehicle", SCC$SCC.Level.Two, ignore.case=TRUE) 
subSCC <- SCC[vehicleRel,]$SCC
subNEI <- NEI[NEI$SCC %in% subSCC,]
vehicleBalt <- subNEI[which(subNEI$fips == "24510"),]
vehicleBalt$city <- "Baltimore"
vehicleLA <- subNEI[which(subNEI$fips == "06037"),]
vehicleLA$city <- "Los Angeles"
BaltLA <- rbind(vehicleBalt,vehicleLA)

# Generate plot
png("plot6.png")

ggplot(data=subset(BaltLA,!is.na(year)), aes(x=factor(year), y=Emissions, fill=city)) +
  geom_bar(aes(fill=year),stat="identity") +
  facet_grid(scales="free", space="free", .~city) +
  guides(fill=FALSE) + theme_bw() +
  labs(x="year", y=expression("Total PM2.5 Emission")) + 
  labs(title=expression("Total PM2.5 Emissions in Baltimore and Los Angeles City"))
dev.off()