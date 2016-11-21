#definer filsti
setwd("~/GitHub/vkme16/")

#indlæs nogle pakker
require(haven)
require(dplyr)
require(stargazer)

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

###

# housekeeping
rm(list=ls())

# indlæs larsen et al data
ld<-read_dta("data/3_larsen.dta")

#overblik over data med glimpse()
glimpse(ld)

# estimer ren cross-sectional model
m1<-lm(incsupport~hp_1yr,data=ld)
summary(m1)

#estimer model med year FE
m2<-lm(incsupport~hp_1yr+factor(year),data=ld)
summary(m2) # helt umuligt at læse output :-/

#estimer model med year og valgsted FE
m3<-lm(incsupport~hp_1yr+factor(year)+factor(valgstedid),data=ld)
summary(m3) # helt umuligt at læse output :-/

#her tryller jeg lidt med pakken stargazer (pakke til tabelpræsentation) for at præsentere resultaterne
stargazer(m1,m2,m3,style="apsr",type="text",omit="factor")

