setwd("Z:/Data/Eurobarometer")
setwd("~/Dropbox/teaching/vkm_e16/midterm")

require(readr)
require(dplyr)
require(magrittr)
require(janitor)
require(interplot)
require(lme4)
require(cem)
require(stargazer)

ebtest<-read.csv("ebcsv.csv")


#1
table(ebtest$membrshp)
ebtest$membrshp<-convert_to_NA(ebtest$membrshp,8:9)
cntrymeans<-tapply(ebtest$membrshp, ebtest$cntryname, mean, na.rm=T)
cntrymeans<-data.frame(name=rownames(cntrymeans),value=as.numeric(cntrymeans))
cntrymeans

#2
table(ebtest$income)
table(ebtest$educ)
table(ebtest$lrs)
ebtest$income<-convert_to_NA(ebtest$income,96:99)
ebtest$educ<-convert_to_NA(ebtest$educ,96:99)
ebtest$lrs<-convert_to_NA(ebtest$lrs,96:99)
ebtest$matpmat<-convert_to_NA(ebtest$matpmat,7:9)
ols1<-lm(membrshp~income,data=ebtest)
ols2<-lm(membrshp~income+age+sex+educ,data=ebtest)
ols3<-lm(membrshp~income+age+sex+educ+lrs,data=ebtest)
stargazer(ols1,ols2,ols3,type="text")

#4
ols4<-lm(membrshp~income*educ+age+sex+lrs,data=ebtest)
stargazer(ols1,ols2,ols3,ols4,type="text")
interplot(ols4,"income","educ")

#5
ols1fe<-lm(membrshp~income+factor(nation2)+factor(year),data=ebtest)
ols2fe<-lm(membrshp~income+age+sex+educ+factor(nation2)+factor(year),data=ebtest)
ols3fe<-lm(membrshp~income+age+sex+educ+lrs+factor(nation2)+factor(year),data=ebtest)
stargazer(ols1fe,ols2fe,ols3fe,type="text",omit="factor")

#6
ols2c<-lm(membrshp~income+age+sex+educ+catholicpct,data=ebtest)
ols2cmlm<-lmer(membrshp~income+age+sex+educ+catholicpct+(1|nation2),data=ebtest)
stargazer(ols2c,ols2cmlm,type="text")

#8
varslope<-lmer(membrshp~income+age+sex+educ+catholicpct+(1+income|nation2),data=ebtest) #yikes!
coef(varslope)$nation2

#9
slopesdf<-data.frame(nation2=rownames(coef(varslope)$nation2),
                     slope=coef(varslope)$nation2$income,
                     catholicpct=tapply(ebtest$catholicpct,ebtest$nation2,min))

summary(lm(slope~catholicpct,data=slopesdf))

#10
ebtest$income_lohi<-ifelse(ebtest$income>6,1,0) #dichotomous income var
nomatchvars<-c("catholicpct","cntryname","nation2","income","membrshp","income_lohi","regionat")
ebr<-sample_frac(ebtest,.05)
imbalance(ebr$income_lohi,ebr,drop=nomatchvars)
ebmatch<-cem("income_lohi",ebr,drop=nomatchvars)
imbalance(ebr[ebmatch$matched,]$income_lohi,ebr[ebmatch$matched,],drop=nomatchvars)
ols3fer<-lm(membrshp~income+age+sex+educ+lrs+factor(nation2)+factor(year),data=ebr)
ols3ferm<-lm(membrshp~income+age+sex+educ+lrs+factor(nation2)+factor(year),data=ebr[ebmatch$matched,])
stargazer(ols3fer,ols3ferm,type="text")
