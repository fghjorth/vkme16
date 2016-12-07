setwd("~/GitHub/vkme16")

require(readr)
require(AER) #anvendt økonometri
require(sandwich) #robuste standardfejl
require(stargazer)

#indlæs data
ggd<-read_csv("data/8_gg.csv")
ggd<-subset(ggd,onetreat==1 & mailings==0 & phongotv==0 & persons==1)

#estimer model hvor assignment bruges som instrument for treatment
ivmodel<-ivreg(v98~cntany,~persngrp,data=ggd)

#vektor med robuste standardfejl
robustses<-sqrt(diag(vcovHC(ivmodel,type="HC")))
#vcovHC() giver varians-kovariansmatricen for robuste se
#diag() tager matricens diagonal, dvs. variablenes varianser
#sqrt() tager variansernes kvadratrod, dvs. standardfejl

#rapporter model u. robuste standardfejl
stargazer(ivmodel,type="text",digits=6)

#rapporter model m. robuste standardfejl
stargazer(ivmodel,type="text",digits=6,se=list(robustses))

