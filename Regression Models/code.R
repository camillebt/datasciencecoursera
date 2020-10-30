#Load mtcars dataset from R and view variables
data(mtcars)
head(mtcars,3)

#Change am from numeric to factor
mtcars$am <- as.factor(mtcars$am)
levels(mtcars$am)<-c("Auto","Manual")

#Plot MPG based on am variable
library(ggplot2)
ggplot(mtcars, aes(x = am,y = mpg))+
  geom_boxplot(aes(fill =am))+
  labs(x ="Transmission Type",
       y = "MPG",
       title = "Manual vs Automatic Transmission: MPG")+
  scale_fill_discrete(labels = c("Automatic", "Manual"))

#Initial t Test
t.test(mtcars$mpg[mtcars$am=="Auto"],mtcars$mpg[mtcars$am=="Manual"])

#Simple linear regression
lmFit <- lm(mpg ~ am,mtcars)
summary(lmFit)

#Step Linear Regression
stepLM <- step(lm(mpg~.,data=mtcars),direction="both")
summary(stepLM) 

#ANOVA
simpleLM <- lm(mpg ~ am, mtcars)
multiLM <- lm(mpg ~ am + wt + qsec, mtcars)
anova(simpleLM, multiLM)

#Diagnostic PLots
layout(matrix(1:4,2,2))
plot(simpleLM)

fit2 <- lm(formula = mpg ~ am + cyl + hp + wt, data = mtcars)
anova(multiLM,fit2)
