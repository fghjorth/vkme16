#definer filsti
setwd("~/GitHub/vkme16/")

#pakker
require(haven) 
require(dplyr)

#indlæs data
gd<-read_dta("data/2_gilens.dta")

#fjern missing i dep var
gd<-mutate(gd,outcome_rc=ifelse(OUTCOME==99,NA,OUTCOME))

#ols modeller
m1ols<-lm(outcome_rc~pred50_sw,data=gd)
m2ols<-lm(outcome_rc~pred90_sw,data=gd)

#resultat
summary(m1ols)
summary(m2ols)

#binær afhængig
gd<-mutate(gd,outcome_rc01=ifelse(outcome_rc>0 & outcome_rc < 4,1,0))

#logit modeller
m1logit<-glm(outcome_rc01~pred50_sw,data=gd,family="binomial")
m2logit<-glm(outcome_rc01~pred90_sw,data=gd,family="binomial")

#resultat
summary(m1logit)
summary(m2logit)

#hvor meget korrelerer holdninger for forskellige indkomstgrupper?
plot(gd$pred50_sw,gd$pred90_sw)
