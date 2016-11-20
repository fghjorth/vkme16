> ###################################################
> # R code for "Big Data: New Tricks for Econometrics
> # Journal of Economic Perspectives 28(2), 3-28            
> # http://pubs.aeaweb.org/doi/pdfplus/10.1257/jep.28.2.3
> # Hal R. Varian
> ###################################################
> 
> # load libraries and data
> library(party)
> library(Ecdat)
> data(Hdma)
> # fix annoying spelling error
> names(Hdma)[11] <- "condo"
> 
> # for reproducibility
> set.seed(1234)
> 
> ####################################
> # all complete cases, all predictors
> ####################################
> 
> all <- Hdma[complete.cases(Hdma),]
> all.fit <- ctree(deny ~ .,data=all)
> all.pred <- predict(all.fit)
> all.conf <- table(all$deny,all.pred)
> all.conf
     all.pred
        no  yes
  no  2035   60
  yes  168  117
> all.error <- all.conf[2,1]+all.conf[1,2]
> all.error
[1] 228
> 
> #######################################
> # no black predictor
> #######################################
> 
> noblack <- all[,-12]
> noblack.fit <- ctree(noblack$deny ~ .,data=noblack)
> noblack.pred <- predict(noblack.fit)
> 
> # compare these predictions to the "all predictor" predictions
> all.equal(all.pred,noblack.pred)
[1] TRUE
> 
> ####################################
> # remove predictors one-by-one and check error count
> ####################################
> 
> for (t in 1:12) {
+ drop1 <- all[,-t]
+ drop1.fit <- ctree(deny ~ .,data=drop1)
+ drop1.pred <- predict(drop1.fit)
+ drop1.conf <- table(drop1$deny,drop1.pred)
+ error <- (drop1.conf[2,1]+drop1.conf[1,2])
+ print(c(names(all)[t],format((error-all.error),digits=4)))
+ }
[1] "dir" "2"  
[1] "hir" "0"  
[1] "lvr" "6"  
[1] "ccs" "8"  
[1] "mcs" "0"  
[1] "pbcr" "12"  
[1] "dmi" "36" 
[1] "self" "0"   
[1] "single" "0"     
[1] "uria" "0"   
[1] "condo" "0"    
[1] "black" "0"    
> 
> #######################################
> # compare to logit
> #######################################
> logit.fit <- glm(deny ~ .,data=all,family="binomial")
> logit.temp <- predict(logit.fit,type="response")
> logit.pred <- logit.temp > .5
> logit.conf <- table(all$deny,logit.pred)
> logit.conf
     logit.pred
      FALSE TRUE
  no   2066   29
  yes   196   89
> logit.error <- logit.conf[1,2]+logit.conf[2,1]
> logit.error
[1] 225
> all.error
[1] 228
> summary(logit.fit)

Call:
glm(formula = deny ~ ., family = "binomial", data = all)

Deviance Residuals: 
    Min       1Q   Median       3Q      Max  
-2.6980  -0.4210  -0.3083  -0.2235   2.9848  

Coefficients:
            Estimate Std. Error z value Pr(>|z|)    
(Intercept) -7.12889    0.55802 -12.775  < 2e-16 ***
dir          4.77419    1.03944   4.593 4.37e-06 ***
hir         -0.42215    1.23957  -0.341 0.733435    
lvr          1.79795    0.49832   3.608 0.000309 ***
ccs          0.29484    0.03970   7.426 1.12e-13 ***
mcs          0.24643    0.14209   1.734 0.082857 .  
pbcryes      1.22812    0.20439   6.009 1.87e-09 ***
dmiyes       4.51536    0.55381   8.153 3.54e-16 ***
selfyes      0.62242    0.21216   2.934 0.003349 ** 
singleyes    0.40783    0.15611   2.612 0.008989 ** 
uria         0.06866    0.03396   2.022 0.043178 *  
condo       -0.03201    0.16939  -0.189 0.850129    
blackyes     0.72657    0.17956   4.046 5.20e-05 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

(Dispersion parameter for binomial family taken to be 1)

    Null deviance: 1744.2  on 2379  degrees of freedom
Residual deviance: 1271.3  on 2367  degrees of freedom
AIC: 1297.3

Number of Fisher Scoring iterations: 6

> 
> #######################################
> # compare to random forest
> ######################################
> library(randomForest)
randomForest 4.5-36
Type rfNews() to see new features/changes/bug fixes.
> set.seed(1234)
> rf.fit <- randomForest(deny ~ .,data=all,importance=T)
> rf.pred <- predict(rf.fit,type="class")
> rf.conf <- table(all$deny,rf.pred)
> rf.conf
     rf.pred
        no  yes
  no  2062   33
  yes  194   91
> error <- rf.conf[1,2]+rf.conf[2,1]
> error
[1] 227
> imp <- importance(rf.fit)
> rev(sort(imp[,3]))
       dmi        dir        hir        lvr        ccs       pbcr      condo 
0.71351822 0.63946746 0.56441835 0.50275252 0.46101973 0.43809274 0.35173433 
    single        mcs      black       self       uria 
0.32073015 0.30420022 0.25112071 0.19431098 0.03248465 
> 
> # importance plot
> varImpPlot(rf.fit)
> 