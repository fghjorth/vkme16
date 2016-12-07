#lad os sige vi har en variabel med fem værdier + værdier for 'ved ikke' etc.

df<-data.frame(var1=sample(c(1:5,88,99),1000,replace=T))

#vi vil gerne sætte 88 og 99 til NA og reskalere resten til at gå fra 0 til 1
#vi bruger ifelse() til at fjerne 88/99, og omregner de andre værdier

df$var1_rs1<-ifelse(df$var1 > 5 , NA, (df$var1-1)/4)

#hvis vi gerne vil vende variablen om:

df$var1_rs2<-ifelse(df$var1 > 5 , NA, (df$var1-5)/-4)
