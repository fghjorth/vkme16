setwd("~/GitHub/vkme16")

require(haven)
require(lme4)
require(dplyr)

bd<-read_dta("data/4_berkman.dta")

# ols-model hvor vi ignorerer multilevelstruktur
ols<-lm(hrs_allev~phase1+senior_c+female+evol_course,data=bd)
summary(ols)

## varying intercepts

# multilevel-model
mlm1<-lmer(hrs_allev~phase1+senior_c+female+evol_course+(1|st_fip),data=bd)
summary(mlm1)

# hvor stor er ICC?
icc_mlm1<-3.299/(3.299+71.068)

# bemærk: phase1, variabel på statsniveau, kan ikke estimeres i en ols med stat-FE
ols_fe<-lm(hrs_allev~factor(st_fip)+phase1+senior_c+female+evol_course,data=bd)
summary(ols_fe)

## varying slopes

# udvidet model: effekten af evol_course faar lov at variere mellem stater
mlm2<-lmer(hrs_allev~phase1+senior_c+female+evol_course+(1+evol_course|st_fip),data=bd)
summary(mlm2)

# kig paa varierende koefficienter af evol_course per stat
coef(mlm2)$st_fip

## interaktion

#model ligesom mlm1, men med interaktion mellem standarder og anciennitet
mlm3<-lmer(hrs_allev~phase1*senior_c+female+evol_course+(1|st_fip),data=bd)
summary(mlm3)

#for at illustrere interaktioner bruger vi 'interplot'-pakken.
require(interplot)
interplot(mlm3,var1="phase1",var2="senior_c")

#lidt flottere version
interplot(mlm3,var1="phase1",var2="senior_c") +
  theme_bw() +
  geom_hline(yintercept=0,linetype="dashed") +
  labs(x="Seniority",y="Marginal effect of standards")
