# Takes subset for Baltimore only
baltEms <- NEI[which(NEI$fips == "24510"),]

# Generate plot
png("plot3.png")
ggplot(baltEms,aes(factor(year),Emissions,fill=type)) +
  geom_bar(stat="identity") +
  theme_bw() + guides(fill=FALSE)+
  facet_grid(.~type,scales = "free",space="free") + 
  labs(x="year", y=expression("Total PM2.5 Emission")) + 
  labs(title=expression("Total PM2.5 Emissions in Baltimore City"))
dev.off()