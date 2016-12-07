require(dplyr)

# lad os sige vi har et datasæt med tre variable vi tror måler det samme
# (for nemheds skyld antager vi at vi har sat ved ikke til NA allerede)
df<-data.frame(var1=sample(c(0,.25,.5,.75,1,NA),1000,replace=T),
               var2=sample(c(0,.25,.5,.75,1,NA),1000,replace=T),
               var3=sample(c(0,.25,.5,.75,1,NA),1000,replace=T))

# lad os først tjekke indeksets reliabilitet. det gør vi med alpha() i psych-pakken

require(psych)

alpha(as.matrix(select(df,var1:var3))) #alpha skal bruge en matrice med de variable

# reliabiliteten er ikke overraskende meget lav

# vi bruger nu dplyr til at beregne gennemsnittet på tværs af de tre variable og gemme som ny variabel
# rowwise() gør at mean() opererer på tværs af rækker og ikke kolonner
# vi kan vende variablene om bare ved at skrive fx -var2 i stedet for var 2

df<-df %>% 
  rowwise() %>% 
  mutate(varindeks=mean(c(var1,var2,var3),na.rm=T))