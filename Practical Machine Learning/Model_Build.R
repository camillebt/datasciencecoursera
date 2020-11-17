# Using Random Forest

set.seed(24681)

#Random Forest
modRF <- train(classe ~., method = "rf",data=training, preProcess="pca") 
predictRF <- predict(modRF, validating)
cmRF<-confusionMatrix(predictRF, as.factor(validating$classe))
ggplot(data = as.data.frame(cmRF$table),aes(x=Prediction,y=Reference,fill=Freq))+
  geom_tile()+
  theme_light()+
  geom_text(aes(label = Freq),size = 8, color = "white")+
  ggtitle("Random Forest Accuracy = 0.9779")


#Boost
modBoost <- train(classe ~., method = "gbm",data=training, preProcess="pca")
predictBoost <- predict(modBoost, validating)
cmBoost<- confusionMatrix(predictBoost, as.factor(validating$classe))
ggplot(data = as.data.frame(cmBoost$table),aes(x=Prediction,y=Reference,fill=Freq))+
  geom_tile()+
  theme_light()+
  geom_text(aes(label = Freq),size = 8, color = "white")+
  ggtitle("Random Forest Accuracy = 0.8262")

#Decision Trees
modDT <- rpart(classe~., training)
predictDT <- predict(modDT,validating,type = "class")
cmDT <- confusionMatrix(predictDT, as.factor(validating$classe))
ggplot(data = as.data.frame(cmDT$table),aes(x=Prediction,y=Reference,fill=Freq))+
  geom_tile()+
  theme_light()+
  geom_text(aes(label = Freq),size = 8, color = "white")+
  ggtitle("Random Forest Accuracy = 0.7866")