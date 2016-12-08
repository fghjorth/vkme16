setwd("~/GitHub/vkme16/scripts")

require(quanteda)

#motiverende eksempel: meget simple tekster

simpletexts<-c("velfærd velfærd velfærd",
               "velfærd velfærd vækst",
               "velfærd vækst vækst",
               "vækst vækst vækst")
simplecorpus<-corpus(simpletexts,docnames=c("el","s","v","la"))
simpledfm<-dfm(simpletexts)

#tf-idf

tfidf(simpledfm)

#regner efter i hånden
tf<-3
idf<- log10( 4/3 )
tf*idf

#wordscores eksempel

simplews<-textmodel(x=simpledfm,y=c(-1,NA,NA,1),model="wordscores")

predict(simplews)

