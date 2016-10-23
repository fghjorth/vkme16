setwd("~/GitHub/vkme16/")

require(readr)
require(stargazer)
require(dplyr)
require(coefplot)

#indlæs data
ggl<-read_csv("data/7_ggl.csv")

#kig på data
glimpse(ggl)

#regression på turnout af exp treatment
ols1<-lm(primary2006~messages,data=ggl)
summary(ols1)

#gør control til referencekategori
ggl$treatmentfac<-relevel(as.factor(ggl$messages),ref="Control")

#igen: regression på turnout af exp treatment
ols2<-lm(primary2006~treatmentfac,data=ggl)
summary(ols2)

#vis på tabelform
stargazer(ols2,type="text")

#vis som koefficientplot
coefplot(ols2,intercept=F,horizontal=T,color="black")

#vigtigt balancecheck: balance på pre-treatment turnout?
olsbc<-lm(primary2004~treatmentfac,data=ggl)
summary(olsbc)