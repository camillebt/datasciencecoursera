# Find coal and combustion related in SCC and link back to NEI

combRel <- grepl("comb", SCC$SCC.Level.One, ignore.case=TRUE)
coalRel <- grepl("coal", SCC$SCC.Level.Four, ignore.case=TRUE) 
combined <- (combRel & coalRel)
subSCC <- SCC[combined,]$SCC
subNEI <- NEI[NEI$SCC %in% subSCC,]

#Generate plot
png("plot4.png")
ggplot(subNEI,aes(factor(year),Emissions/10^3)) +
  geom_bar(stat="identity",fill="red",width=0.75) +
  theme_bw() +  guides(fill=FALSE) +
  labs(x="year", y=expression("Total PM2.5 Emission in Thousands")) + 
  labs(title=expression("Total PM2.5 Coal Combustion Source Emissions Across US"))

dev.off()