Codebook
================

# Introduction

Fine particulate matter (PM2.5) is an ambient air pollutant for which
there is strong evidence that it is harmful to human health. In the
United States, the Environmental Protection Agency (EPA) is tasked with
setting national ambient air quality standards for fine PM and for
tracking the emissions of this pollutant into the atmosphere.
Approximatly every 3 years, the EPA releases its database on emissions
of PM2.5. This database is known as the National Emissions Inventory
(NEI). You can read more information about the NEI at the EPA National
Emissions Inventory web site.

For each year and for each type of PM source, the NEI records how many
tons of PM2.5 were emitted from that source over the course of the
entire year. The data that you will use for this assignment are for
1999, 2002, 2005, and 2008.

The data for this assignment are available from the course web site as a
single zip file:

[Data for Peer
Assessment](https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip)
\[29Mb\] The zip file contains two files:

PM2.5 Emissions Data (summarySCC\_PM25.rds): This file contains a data
frame with all of the PM2.5 emissions data for 1999, 2002, 2005, and
2008. For each year, the table contains number of tons of PM2.5 emitted
from a specific type of source for the entire year.

fips: A five-digit number (represented as a string) indicating the U.S.
county SCC: The name of the source as indicated by a digit string (see
source code classification table) Pollutant: A string indicating the
pollutant Emissions: Amount of PM2.5 emitted, in tons type: The type of
source (point, non-point, on-road, or non-road) year: The year of
emissions recorded

Source Classification Code Table (Source\_Classification\_Code.rds):
This table provides a mapping from the SCC digit strings in the
Emissions table to the actual name of the PM2.5 source. The sources are
categorized in a few different ways from more general to more specific
and you may choose to explore whatever categories you think are most
useful. For example, source “10100101” is known as “Ext Comb /Electric
Gen /Anthracite Coal /Pulverized Coal”.

# Code

The overall goal of this assignment is to explore the National Emissions
Inventory database and see what it say about fine particulate matter
pollution in the United states over the 10-year period 1999–2008. You
may use any R package you want to support your analysis.

## Reading RDS files

``` r
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
```

## Plots

Question 1: Have total emissions from PM2.5 decreased in the United
States from 1999 to 2008? Using the base plotting system, make a plot
showing the total PM2.5 emission from all sources for each of the years
1999, 2002, 2005, and 2008.

``` r
# Formats data as numeric to prevent scientific notation
NEI$Emissions <- as.numeric(NEI$Emissions)

#Get total emissions regardless of state
totalEms <- aggregate(Emissions ~ year, NEI, sum)

#Generate plot
barplot(totalEms$Emissions/10^6, 
        names = totalEms$year, 
        xlab = "Year", 
        ylab = "Emissions in Mio", 
        main = "Total PM2.5 Emissions in the US")
```

![](Codebook_files/figure-gfm/Plot1-1.png)<!-- -->

Question 2: Have total emissions from PM2.5 decreased in the Baltimore
City, Maryland (fips == “24510”) from 1999 to 2008? Use the base
plotting system to make a plot answering this question.

``` r
# Takes subset for Baltimore only
baltEms <- NEI[which(NEI$fips == "24510"),]

# #Get total emissions per year
totalBalt <- aggregate(Emissions ~ year, baltEms, sum)

#Generate plot
barplot(totalBalt$Emissions, 
        names = totalBalt$year, 
        xlab = "Year", 
        ylab = "Emissions", 
        main = "Total PM2.5 Emissions in Baltimore City")
```

![](Codebook_files/figure-gfm/Plot2-1.png)<!-- -->

Question 3: Of the four types of sources indicated by the type (point,
nonpoint, onroad, nonroad) variable, which of these four sources have
seen decreases in emissions from 1999–2008 for Baltimore City? Which
have seen increases in emissions from 1999–2008? Use the ggplot2
plotting system to make a plot answer this question.

``` r
# Takes subset for Baltimore only
baltEms <- NEI[which(NEI$fips == "24510"),]

#Generate plot
library(ggplot2)

ggplot(baltEms,aes(factor(year),Emissions,fill=type)) +
  geom_bar(stat="identity") +
  theme_bw() + guides(fill=FALSE)+
  facet_grid(.~type,scales = "free",space="free") + 
  labs(x="year", y=expression("Total PM2.5 Emission")) + 
  labs(title=expression("Total PM2.5 Emissions in Baltimore City by Source Type"))
```

![](Codebook_files/figure-gfm/Plot3-1.png)<!-- -->

Question 4: Across the United States, how have emissions from coal
combustion-related sources changed from 1999–2008?

``` r
# Find coal and combustion related in SCC and link subset back to NEI
combRel <- grepl("comb", SCC$SCC.Level.One, ignore.case=TRUE)
coalRel <- grepl("coal", SCC$SCC.Level.Four, ignore.case=TRUE) 
combined <- (combRel & coalRel)
subSCC <- SCC[combined,]$SCC
subNEI <- NEI[NEI$SCC %in% subSCC,]

#Generate plot
ggplot(subNEI,aes(factor(year),Emissions/10^3)) +
  geom_bar(stat="identity",fill="lightskyblue4",width=0.75) +
  theme_bw() +  guides(fill=FALSE) +
  labs(x="year", y=expression("Total PM2.5 Emission in Thousands")) + 
  labs(title=expression("Total PM2.5 Coal Combustion Sourced Emissions Across US"))
```

![](Codebook_files/figure-gfm/Plot4-1.png)<!-- -->

Question 5: How have emissions from motor vehicle sources changed from
1999–2008 in Baltimore City?

``` r
# Find vehicle related in SCC and link back to NEI
vehicleRel <- grepl("vehicle", SCC$SCC.Level.Two, ignore.case=TRUE) 
subSCC <- SCC[vehicleRel,]$SCC
subNEI <- NEI[NEI$SCC %in% subSCC,]
vehicleBalt <- subNEI[which(NEI$fips == "24510"),]

#Generate plot
ggplot(data=subset(vehicleBalt,!is.na(year)),aes(factor(year),Emissions)) +
  geom_bar(stat="identity", fill = "steelblue4",width=0.75,na.rm=TRUE) +
  theme_bw() +  guides(fill=FALSE) +
  labs(x="year", y=expression("Total PM2.5 Emission")) + 
  labs(title=expression("Total PM2.5 Vehicle Sourced Emissions in Baltimore"))
```

![](Codebook_files/figure-gfm/Plot5-1.png)<!-- -->

Question 6: Compare emissions from motor vehicle sources in Baltimore
City with emissions from motor vehicle sources in Los Angeles County,
California (fips == “06037”). Which city has seen greater changes over
time in motor vehicle emissions?

``` r
# Find car related in SCC and link back to NEI
vehicleRel <- grepl("vehicle", SCC$SCC.Level.Two, ignore.case=TRUE) 
subSCC <- SCC[vehicleRel,]$SCC
subNEI <- NEI[NEI$SCC %in% subSCC,]
vehicleBalt <- subNEI[which(subNEI$fips == "24510"),]
vehicleBalt$city <- "Baltimore"
vehicleLA <- subNEI[which(subNEI$fips == "06037"),]
vehicleLA$city <- "Los Angeles"
BaltLA <- rbind(vehicleBalt,vehicleLA)

#Generate plot
ggplot(data=subset(BaltLA,!is.na(year)), aes(x=factor(year), y=Emissions, fill=city)) +
  geom_bar(aes(fill=year),stat="identity") +
  facet_grid(scales="free", space="free", .~city) +
  guides(fill=FALSE) + theme_bw() +
  labs(x="year", y=expression("Total PM2.5 Emission")) + 
  labs(title=expression("Total PM2.5 Emissions in Baltimore and Los Angeles City"))
```

![](Codebook_files/figure-gfm/Plot6-1.png)<!-- -->
