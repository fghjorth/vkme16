setwd("~/GitHub/vkme16/data/14_royalspeeches")

require(quanteda) #tekstanalyse
require(magrittr) #piping
require(dplyr) #databehandling
require(tidyr) #bred til lang form
require(stringr) #regex
require(ggplot2)

####
# 0: IMPORT + PRE-PROCESSING
####

#vektor med filnavnene
speechfilenames<-list.files()

#lav et tekstkorpus
royalcorpus<-corpus(textfile(speechfilenames,encoding="ISO-8859-1"))
#textfile() sikrer at den læser teksterne og ikke bare filnavnene
#bemærk: fixet bogstaver ved at specificere encoding ved import

#summary af teksterne i korpusset
summary(royalcorpus)

#document-feature-matrice
royaldfm<-dfm(royalcorpus)

#lidt mere 'trimmet' matrice: stem + fjern stopord
royaldfm2<-dfm(royalcorpus,ignoredFeatures=stopwords("danish"),stem=T,language="danish")

#sammenlign de to matricer
head(royaldfm)
head(royaldfm2)

####
# 1: TF-IDF
####

#beregn tf-idf for hvert ord
royaltfidf<-tfidf(royaldfm2)

# kig på de første celler
head(royaltfidf)

####
# 2: WORDSCORES
####

#vi skal først definere en vector med 'reference scores'
#det giver ikke super meget mening her, men lad os for eksemplets skyld sige at 
#1975 er mest venstreorienteret, 2001 mest højreorienteret
refscores<-c(rep(NA,length(1946:1974)),
             -1,
             rep(NA,length(1976:2000)),
             1,
             rep(NA,length(2002:2015)))

#kør wordscores
royal_ws<-textmodel(royaldfm2,refscores,model="wordscores")

#data frame med wordscores-estimater pr dokument
royal_ws_ests<-predict(royal_ws)@textscores

####
# EKSTRA
####

#mest enkle plot: wordcloud
plot(royaldfm2)

#lad os se top 5 tf-idf per år
#der sker en hel masse her - men bemærk at sekvensen er relativt overskuelig takket være piping
royaltfidfsum<-royaltfidf %>% 
  as.data.frame() %>% 
  mutate(doc=rownames(.)) %>% 
  gather(ord,tfidf,-doc) %>% 
  group_by(doc) %>% 
  arrange(-tfidf) %>% 
  top_n(10,tfidf) %>% 
  slice(1:10) %>% 
  mutate(rank=1:10) %>% 
  ungroup() %>% 
  arrange(doc) %>% 
  mutate(year=as.numeric(str_extract(doc,"[0-9]*")))

#plot de mest unikke ord pr. år
ggplot(royaltfidfsum,aes(x=year,y=rank)) +
  geom_text(aes(x=year,y=rank,label=ord,size=tfidf),angle=-25) +
  theme_bw() +
  theme(legend.position = "none")
  
#data frame med wordscores output
royal_ws_df<-predict(royal_ws)@textscores %>% 
  mutate(year=1946:2015)

#plot
ggplot(royal_ws_df,aes(year,textscore_raw)) +
  geom_point() +
  geom_errorbar(aes(ymin=textscore_raw_lo,ymax=textscore_raw_hi),width=0) +
  theme_bw()


####
# REGNEEKSEMPEL FRA SLIDES
####

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

