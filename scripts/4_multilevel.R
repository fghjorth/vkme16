setwd("~/GitHub/vkme16")

require(haven)
require(lme4)
require(dplyr)
require(magrittr)

nd<-read_dta("data/4_anes.dta")

ols1<-lm(presvote~stateinc,data=nd)
summary(ols1)

mlm1<-lmer(presvote~stateinc+(1|state),data=nd)
summary(mlm1)

mlm2<-lmer(presvote~stateinc+incgroup+(1|state),data=nd)
summary(mlm2)

mlm3<-lmer(presvote~incgroup+(1+incgroup|state),data=nd)
summary(mlm3)

statecoefs<-coef(mlm3)$state
statecoefs$state<-rownames(statecoefs)

stateincs<-data.frame(tapply(nd$stateinc,nd$state,FUN=median))
stateincs<-data.frame(state=rownames(stateincs),stateinc=as.numeric(stateincs[,1]))

statecoefs<-left_join(statecoefs,stateincs,by="state")
  
stateranefs<-ranef(mlm3)$state
stateranefs$state<-rownames(stateranefs)
stateranefs<-left_join(stateranefs,stateincs,by="state")
plot(stateranefs$stateinc,stateranefs$incgroup)
