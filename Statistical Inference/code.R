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

#Histogram showing overview of mean per trial
hist(matMean, xlab = "Mean per trial", 
     main = "Mean Simulation Overview", 
     abline(v = theoMean, col = "firebrick",lwd=3),
     col = "mediumseagreen")

#Show the sample mean and compare it to the theoretical mean of the distribution
sampleMean <- mean(matMean)

