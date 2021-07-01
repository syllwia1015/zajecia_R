load('../Cw05_2021_06_26/ofertyV.RData')

# install.packages(c("caTools","randomForest","rpart","e1071","kknn","caret","mlr"))
library(caTools)
library(randomForest)
library(rpart)
library(e1071)
library(kknn)
library(caret)

set.seed(123)
sample<-sample.split(Y=ofertyV,SplitRatio = .75)
trains<-subset(ofertyV,sample==TRUE)
tests<-subset(ofertyV,sample==FALSE)


# KNN
regrKNN<-train.kknn(cena~.,data=trains,kmax=15)
predictionsKNN<-predict(regrKNN,tests)
myMAEKNN<-mean(abs(tests$cena-predictionsKNN))


# Random Forest
rf_model <- randomForest(cena~.,data=trains)
predictionsRF<-predict(rf_model,tests)
myMAERF<-mean(abs(tests$cena-predictionsRF))

meanMAE <- mean(abs(tests$cena - mean(ofertyV$cena)))

# Random Forest
# rf_default <- caret::train(cena~., 
#                     data=trains, 
#                     method='rf')

# lm z caret
control<-trainControl(method = "cv",10)
modelLM<-caret::train(cena~.,data=trains,method="lm",trControl=control)
predictedLM<-predict(modelLM,tests)
summary(modelLM)
postResample(predictedLM,tests$cena)

# boosting
modelxgb<-caret::train(cena~.,data=trains,method="xgbTree",trControl=control)
predictedXGB<-predict(modelxgb,tests)
summary(modelxgb)
postResample(predictedXGB,tests$cena)



library(mlr)
library(dplyr)

sample<-sample.split(Y=ofertyV,SplitRatio = .2)
maleV<-subset(ofertyV,sample==TRUE)
maleV<-maleV%>%droplevels()

names(maleV)
names(maleV)<-gsub("ść","sc",names(maleV))
names(maleV)<-gsub("ó","o",names(maleV))

zadanieRegresja<-mlr::makeRegrTask(id="regresja",maleV,target="cena")
zadanieRegresja<- mergeSmallFactorLevels(zadanieRegresja,min.perc=0.01,new.level = ".merged")
levels( (getTaskData(zadanieRegresja)$Model_pojazdu ) )

n<-getTaskSize(zadanieRegresja)
set.seed(123)
train.set<-sample(n, size=(n*3/4) )
'%ni%'<-Negate('%in%')
test.set<-seq(1,n,by=1)
test.set<-test.set[test.set%ni%train.set]

learner_rpart<-makeLearner("regr.rpart",id="rpart")
cost_rpart<-mlr::train(learner_rpart,zadanieRegresja,subset = train.set)
fitted_rpart<-predict(cost_rpart,zadanieRegresja,subset=test.set)
maeRPART<- mean( abs(fitted_rpart$data$truth-fitted_rpart$data$response) )

library(ranger)
learner_ranger<-makeLearner("regr.ranger",id="ranger")
cost_ranger<-mlr::train(learner_ranger,zadanieRegresja,subset = train.set)
fitted_ranger<-predict(cost_ranger,zadanieRegresja,subset=test.set)
maeRANGER<- mean( abs(fitted_ranger$data$truth-fitted_ranger$data$response) )



# dzialanie dla OferyV
library(mlr)
library(dplyr)

sample<-sample.split(Y=ofertyV,SplitRatio = .2)
maleV<-subset(ofertyV,sample==TRUE)
maleV<-maleV%>%droplevels()

names(ofertyV)
names(ofertyV)<-gsub("ść","sc",names(ofertyV))
names(ofertyV)<-gsub("ó","o",names(ofertyV))

zadanieRegresja<-mlr::makeRegrTask(id="regresja",ofertyV,target="cena")
zadanieRegresja<- mergeSmallFactorLevels(zadanieRegresja,min.perc=0.01,new.level = ".merged")
levels( (getTaskData(zadanieRegresja)$Model_pojazdu ) )

n<-getTaskSize(zadanieRegresja)
set.seed(123)
train.set<-sample(n, size=(n*3/4) )
'%ni%'<-Negate('%in%')
test.set<-seq(1,n,by=1)
test.set<-test.set[test.set%ni%train.set]

learner_rpart<-makeLearner("regr.rpart",id="rpart")
cost_rpart<-mlr::train(learner_rpart,zadanieRegresja,subset = train.set)
fitted_rpart<-predict(cost_rpart,zadanieRegresja,subset=test.set)
maeRPART<- mean( abs(fitted_rpart$data$truth-fitted_rpart$data$response) )

library(ranger)
learner_ranger<-makeLearner("regr.ranger",id="ranger")
cost_ranger<-mlr::train(learner_ranger,zadanieRegresja,subset = train.set)
fitted_ranger<-predict(cost_ranger,zadanieRegresja,subset=test.set)
maeRANGER<- mean( abs(fitted_ranger$data$truth-fitted_ranger$data$response) )



learner_svm<-makeLearner("regr.svm",id="svm")
cost_svm<-mlr::train(learner_svm,zadanieRegresja,subset = train.set)
fitted_svm<-predict(cost_svm,zadanieRegresja,subset=test.set)
maesvm<- mean( abs(fitted_svm$data$truth-fitted_svm$data$response) )

learner_rf<-makeLearner("regr.randomForest",id="rf", fix.factors.prediction = T)
cost_rf<-mlr::train(learner_rf,zadanieRegresja,subset = train.set)
fitted_rf<-predict(cost_rf,zadanieRegresja,subset=test.set)
maerf<- mean( abs(fitted_rf$data$truth-fitted_rf$data$response) )

learner_lm<-makeLearner("regr.lm",id="lm",  fix.factors.prediction = T)
cost_lm<-mlr::train(learner_lm,zadanieRegresja,subset = train.set)
fitted_lm<-predict(cost_lm,zadanieRegresja,subset=test.set)
maelm<- mean( abs(fitted_lm$data$truth-fitted_lm$data$response) )


learner_knn<-makeLearner("regr.kknn",id="kknn",  fix.factors.prediction = T)
cost_knn<-mlr::train(learner_knn,zadanieRegresja,subset = train.set)
fitted_knn<-predict(cost_knn,zadanieRegresja,subset=test.set)
maelm<- mean( abs(fitted_knn$data$truth-fitted_knn$data$response) )


cost_benchmark<- mlr::benchmark(list(learner_ranger, learner_rf,learner_lm,learner_svm, learner_knn, learner_rpart),resamplings = cv3,measures = mae,tasks = zadanieRegresja)
plotBMRBoxplots(cost_benchmark)


ctrl<-makeTuneControlRandom(maxit = 10)
rdesc<-makeResampleDesc("CV",iters=3)
params<-makeParamSet(makeIntegerParam("num.trees",500,1000) )
?ranger
resKK<-tuneParams(learner_ranger,task=zadanieRegresja,resampling = rdesc,par.set = params,control=ctrl,measures = mae)
learner_rf_tuned<-makeLearner("regr.ranger",id="rftuned",fix.factors.prediction = TRUE)
learner_rf_tuned<-setHyperPars(learner_rf_tuned,par.vals = resKK$x)



cost_benchmark<- mlr::benchmark(list(learner_ranger,learner_rf_tuned,learner_lm,learner_svm, learner_kknn, learner_rpart),resamplings = cv3,measures = mae,tasks = zadanieRegresja)
plotBMRBoxplots(cost_benchmark,pretty.names = FALSE)

