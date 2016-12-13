## BRUG AF SAMME OBSERVATIONER PÅ TVÆRS AF MODELLER

require(stargazer)

setwd("~/GitHub/vkme16/")

#vi loader et datasæt - det fra midterm'en
mtd<-readRDS("midterm/midtermdata.rds")

#lad os lave tre modeller med forskellige grader af missingness
ols1a<-lm(membrshp~age,data=mtd)
ols2a<-lm(membrshp~age+sex+educ,data=mtd)
ols3a<-lm(membrshp~age+sex+educ+income+matpmat,data=mtd)

#kig på resultaterne
stargazer(ols1a,ols2a,ols3a,style="apsr",type="text")

#hmm, det ville være fedt at bruge samme obs i alle tre
#det gør vi ved at udnytte at alle modelobjekter inkluderer en vektor som angiver de observationer, der ikke er med i modellen
missingin3a<-ols3a$na.action

#ved at lave et nyt datasæt der frasorterer de obs. kan vi køre alle tre modeller på netop dem er bruges i 3a
mtd_3aobs<-mtd[-missingin3a,]

#modellerne igen med den nye df
ols1b<-lm(membrshp~age,data=mtd_3aobs)
ols2b<-lm(membrshp~age+sex+educ,data=mtd_3aobs)
ols3b<-lm(membrshp~age+sex+educ+income+matpmat,data=mtd_3aobs)

#tjekker efter
stargazer(ols1b,ols2b,ols3b,style="apsr",type="text")
