setwd("~/GitHub/vkme16/")

require(dplyr)
require(rpart) #regression trees
require(rpart.plot) #plot pænere regressionstræer
require(glmnet) #lasso

#hent det store datasæt fra midterm-opgaven
eb<-readRDS("midterm/midtermdata.rds") #rds er et kompakt format til at gemme r-objekter

#skal først lave nyt data uden NA's
eb2<-eb %>% 
  dplyr::select(membrshp,age,sex,educ,income,lrs,matpmat) %>% 
  na.omit() %>% 
  mutate(membrshp01=ifelse(membrshp>1,0,1)) #bytter rundt så 1=pro-EU

#baseline: en logit-model
ebformula<-as.formula(membrshp01~age+sex+educ+income+lrs+matpmat)
summary(logit<-glm(ebformula,data=eb2,family="binomial"))

#fit et regressionstræ
regtree<-rpart(ebformula,data=eb2,control=rpart.control(minsplit=30, cp=0.0001))
prp(regtree)

#til LASSO skal vi bruge en matrice kun med inputvariablene
ebinputmat<-as.matrix(dplyr::select(eb2,-membrshp,-membrshp01))

#fit en LASSO-regression
lasso<-glmnet(x=ebinputmat,y=eb2$membrshp01,family="binomial")

#plot lasso koefficienter som funktion af tuningparameteren lambda
plot(lasso,xvar="lambda",label=T)
lasso$beta@Dimnames[[1]] #navne der svarer til labels på plottet
