setwd("~/GitHub/vkme16/")

require(rvest)
require(dplyr)
require(magrittr)
require(stringr)
require(ggplot2)

###
# DEL 1: SCREEN SCRAPING
###

krurl<-"https://da.wikipedia.org/wiki/Konger%C3%A6kken"

#først indlæser vi websiden
kr<-read_html(krurl)

#så udtrækker vi alle tabeller fra siden
kr_tables<-html_nodes(kr,"table")
kr_tables

#det var mange tabeller :-/ ved at bruge CSS-selectoren 'wikitable' kan vi fokusere på de interessante tabeller (bemærk punktummet)
kr<-html_nodes(kr,".wikitable")
kr

#tabellerne fra 1-3 er vist dem vi skal bruge
#her bruger vi extract2() fra magrittr til at vælge de rigtige (extract2 vælger items fra lister)
kr1<-extract2(kr,1)

#gemmer som tabel (fill=T sørger for at tomme celler bare sættes som missing)
kr1<-html_table(kr1,fill=T)

#vi gemmer de andre på samme måde og samler
kr2<-html_table(extract2(kr,2),fill=T)
kr3<-html_table(extract2(kr,3),fill=T)

#samler alle tre
kr_all<-bind_rows(kr1,kr2,kr3)

#fjerner ekstra rækker
kr_all<-filter(kr_all,Navn!="Navn")

#det hele kan gøres meget mere kompakt med piping
kr1<-krurl %>% 
  read_html() %>% 
  html_nodes(".wikitable") %>% 
  extract2(1) %>% 
  html_table(.,fill=T)

#lidt ekstra trylleryl: fødsels/dødsår
names(kr_all)[3:5]<-c("Foedt","Tiltraadt","Doed")
kr_all<-kr_all %>% 
  mutate(byear=str_extract(Foedt,"\\d{3,}")) %>% #udtrækker tal med 3 eller flere cifre
  mutate(dyear=str_extract(Doed,"\\d{3,}")) %>% 
  mutate(number=row_number(),
         yrs=as.numeric(dyear)-as.numeric(byear))

#plot
ggplot(kr_all,aes(number,yrs)) +
  geom_point()

###
# DEL 2: API'ER
###

require(twitteR)
key<-"xxx"
secret<-"yyy"  
setup_twitter_oauth(key,secret)

#info om udvalgt twitter-bruger: LLR
llr<-getUser("larsloekke")

#info om LLR
str(llr)

#hvem følger LLR? 
llr_followers<-llr$getFollowerIDs(n=1000)

#find LLR's seneste 200 tweets
llrtweets<-userTimeline(llr,n=200)

#gem som df
llrtweetsdf<-twListToDF(llrtweets)

#kig på tweets efter emneord
rgtweets<-searchTwitter("regeringsgrundlag",n=100)

#gem som df
rgtweetsdf<-twListToDF(rgtweets)
