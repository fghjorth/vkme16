setwd("~/GitHub/vkme16/")

require(haven)
require(stargazer)
require(cem) #coarsened exact matching
require(dplyr)

#indlæs data
ld<-read_dta("data/6_laddlenz.dta")

#bivariat model
ols1<-lm(vote_l_97~tolabor,data=ld)
summary(ols1)

#model med kontroller (jf Ladd/Lenz s 402)
ols2<-lm(vote_l_97~tolabor+vote_l_92+vote_c_92+vote_lib_92+
           labor+conservative+liberal+labfel92+confel92+know_3,data=ld)
summary(ols2)

#sammenlign koefficienterne
stargazer(ols1,ols2,type="text",keep="tolabor")

#reducer data til de variable der er med i ols2
ld<-dplyr::select(ld,vote_l_97,tolabor,vote_l_92,vote_c_92,vote_lib_92,labor,conservative,liberal,labfel92,confel92,know_3)

#konverter fra havens importformat til data frame (som nogle ældre pakker forudsætter)
ld<-as.data.frame(ld)

#evaluer balance
imbalance(group=ld$tolabor,data=ld,drop=c("tolabor","vote_l_97"))

#kør matching
cemmatch1<-cem(treatment="tolabor",data=ld,drop="vote_l_97")

#ny data frame med kun de matchede observationer
ldmatched<-ld[cemmatch1$matched,]

#evaluer balance på det matchede data
imbalance(group=ldmatched$tolabor,data=ldmatched,drop=c("tolabor","vote_l_97"))

#vi kan nu køre regressionen på det matchede data
ols2matched<-lm(vote_l_97~tolabor+vote_l_92+vote_c_92+vote_lib_92+
                  labor+conservative+liberal+labfel92+confel92+know_3,data=ldmatched)

#sammenlign koefficienterne
stargazer(ols1,ols2,ols2matched,type="text",keep="tolabor")

