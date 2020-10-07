#set the seed
set.seed(200)

#details we were given
lambda <- 0.2
n <- 40
sim <- 1000

#simulate the figures
sampleNum <- replicate(sim, rexp(n,lambda))
sampleMat <- matrix(sampleNum, sim, n)

#compute the mean 
matMean <- rowMeans(sampleMat)
theoMean <- 1/lambda
sampleMean <- mean(matMean)

#Histogram showing overview of mean per trial
library(ggplot2)
hist(matMean, xlab = "Mean per trial", 
     main = "Mean Simulation Overview",
     abline(v = theoMean, col = "firebrick",lwd=3),
     #breaks = 10,
     col="mediumseagreen")

qplot(matMean,geom="histogram",
      binwidth = 0.35,
      main = "Mean Simulation Overview",
      xlab = "Mean per Trial",
      ylab = "Frequency",
      fill=I("aliceblue"),
      col=I("black"))+
  geom_vline(aes(xintercept = theoMean, color="Theoretical_Mean"),size=1)+
  geom_vline(aes(xintercept = sampleMean, color="Sample_Mean"),size=1)+
  scale_color_manual(name = "Legend", values = c(Theoretical_Mean = "forestgreen", Sample_Mean = "firebrick"))
  

#Show the sample mean and compare it to the theoretical mean of the distribution
theoMean - sampleMean

#Calculate sample and theoretical variance
sampleVar <- var(matMean)
theoVar <- ((1/lambda)^2)/n
cat("Sample variance is",sampleVar,"and theoretical variance is",
    theoVar,"with difference of",abs(theoVar - sampleVar))

#Plotting the mean with density line using both theoretical and sample mean and variance
ggplot(as.data.frame(matMean), aes(x=matMean))+
  geom_histogram(aes(y =..density..),binwidth = 0.1,fill=I("seagreen"),col=I("black"))+
  labs(x = "Mean per Trial",
  y = "Frequency",
  title = "Mean Simulation Overview")+
  stat_function(fun = dnorm, args = list(mean=sampleMean, sd=sqrt(sampleVar)),aes(color="Sample_Curve"),lwd=1)+
  scale_color_manual(name = "Legend", values = c(Sample_Curve = "lightseagreen"))

