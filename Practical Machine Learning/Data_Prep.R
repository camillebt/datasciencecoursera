# Download Data

trainurl <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
testurl <-"https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"
train <-read.csv(trainurl)
testing <-read.csv(testurl)


# Partition train set into train1 and test1 set
inTrain <- createDataPartition(y=train$classe,
                               p = 0.7, list = FALSE)
training <-train[inTrain,]
validating <-train[-inTrain,]

# Remove variables with near zero variance
zeroVar <- nearZeroVar(training)
training <- training[,-zeroVar]
validating <- validating[,-zeroVar]
testing <- testing[,-zeroVar]

# Remove variables with more than 95% NA 
naObs <- sapply(training, function(x) mean(is.na(x))) > 0.95
training <- training [, naObs == FALSE]
validating <- validating [, naObs == FALSE]
testing <- testing [, naObs == FALSE]

# Omit descriptive columns (primary key, user_name, timestamps)
training <- training[,-(1:5)]
validating <- validating[,-(1:5)]
testing <- testing[,-(1:5)]

# Exploratory Data Analysis
str(training)

# Check for correlation in the remaining columns
corMatrix <- cor(training[, -54])
corrplot(corMatrix, order = "FPC",
         method = "color", type = "lower",
         tl.cex = 0.3, tl.col = "black")


