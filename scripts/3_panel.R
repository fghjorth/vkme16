#definer filsti
setwd("~/GitHub/vkme16/")

#indlæg nogle pakker
require(haven)
require(dplyr)

#simuler et meget enkelt datasæt
simdat<-data.frame(y=c(2,8,11),x=c(1,3,5))

#kovarians og varians
kovariansxy<-cov(simdat$x,simdat$y)
variansx<-var(simdat$x)
variansy<-var(simdat$y)

#udregn regressionskoefficient og bivariat korrelation
regkoefx<-kovariansxy/variansx
korrkoefxy<-kovariansxy/(sqrt(variansx)*sqrt(variansy))

#tjek
summary(lm(y~x,data=simdat))
cor.test(simdat$x,simdat$y)
