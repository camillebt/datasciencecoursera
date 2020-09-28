# Find car related in SCC and link back to NEI
vehicleRel <- grepl("vehicle", SCC$SCC.Level.Two, ignore.case=TRUE) 
subSCC <- SCC[vehicleRel,]$SCC
subNEI <- NEI[NEI$SCC %in% subSCC,]
vehicleBalt <- subNEI[which(NEI$fips == "24510"),]

#Generate plot
png("plot5.png")
ggplot(data=subset(vehicleBalt,!is.na(year)),aes(factor(year),Emissions)) +
  geom_bar(stat="identity",fill="grey",width=0.75,na.rm=TRUE) +
  theme_bw() +  guides(fill=FALSE) +
  labs(x="year", y=expression("Total PM2.5 Emission")) + 
  labs(title=expression("Total PM2.5 Vehicle Source Emissions in Baltimore"))
dev.off()
