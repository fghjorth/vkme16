setwd("~/GitHub/vkme16/scripts")

require(quanteda)

#motiverende eksempel: meget simple tekster

simpletexts<-list(el=c("velfærd velfærd velfærd"),
                  sd=c("velfærd velfærd vækst"),
                  v=c("velfærd vækst vækst"),
                  la=c("vækst vækst vækst"))

simplecorpus<-corpus(unlist(simpletexts),docnames=names(simpletexts))

simpledfm<-dfm(unlist(simpletexts))

tfidf(simpledfm)

simplewf<-textmodel_wordfish(simpledfm,dir=c(1,4))
simplews<-textmodel_wordscores(simpledfm,)