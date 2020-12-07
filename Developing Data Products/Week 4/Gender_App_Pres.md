Philippines Employment by Sex Data Visualization
========================================================
author: Camille Tolentino
date: Dec 6, 2020
autosize: true

Introduction
========================================================

The aim of the application is to visualize the data collected by the World Bank group on the gap between males and females in terms of different indicators related to employment. 

The app can be found [here](https://camillebt.shinyapps.io/sexPlot/) while the source code for the app and this presentation is [here](https://github.com/camillebt/datasciencecoursera/tree/master/Developing%20Data%20Products/Week%204)

Data Source
========================================================

The dataset was taken from [World Bank Group Gender Indicators for the Philippines](https://data.humdata.org/dataset/bfeb4908-1629-4ae1-ab35-d9010838a1bf/resource/c1ce368c-82d8-4b0d-a2dc-c67f085778f5/download/gender_phl.csv).  

It has different indicators taken over different years that shows the the percentage of males in females as employers and employees in different sectors.  


```
     Country Name Country.ISO3 Year
1382  Philippines          PHL 2020
1383  Philippines          PHL 2019
1384  Philippines          PHL 2018
                                                                             Indicator
1382 Employment in agriculture, female (% of female employment) (modeled ILO estimate)
1383 Employment in agriculture, female (% of female employment) (modeled ILO estimate)
1384 Employment in agriculture, female (% of female employment) (modeled ILO estimate)
                  Code  Value
1382 SL.AGR.EMPL.FE.ZS 13.174
1383 SL.AGR.EMPL.FE.ZS 13.778
1384 SL.AGR.EMPL.FE.ZS 14.361
```


App Plot
========================================================

Using the Indicator to get the subset of the data that the user wishes to visualize, a plot similar to the below is printed out upon clicking "Submit". 

<img src="Gender_App_Pres-figure/unnamed-chunk-2-1.png" title="plot of chunk unnamed-chunk-2" alt="plot of chunk unnamed-chunk-2" style="display: block; margin: auto;" />

