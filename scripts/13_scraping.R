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
kr<-html_nodes(kr,"table")

#lad os kigge på hvad vi har nu
kr

#tabellerne fra 14-16 er vist dem vi skal bruge
#her bruger vi extract2() fra magrittr til at vælge de rigtige (extract2 vælger items fra lister)
kr1<-extract2(kr,14)

#gemmer som tabel (fill=T sørger for at tomme celler bare sættes som missing)
kr1<-html_table(kr1,fill=T)

#vi gemmer de andre på samme måde og samler
kr2<-html_table(extract2(kr,15),fill=T)
kr3<-html_table(extract2(kr,16),fill=T)

#samler alle tre
kr_all<-bind_rows(kr1,kr2,kr3)

#fjerner ekstra rækker
kr_all<-filter(kr_all,Navn!="Navn")

#det hele kan gøres meget mere kompakt med piping
kr1<-krurl %>% 
  read_html() %>% 
  html_nodes("table") %>% 
  extract2(14) %>% 
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

llr<-getUser("larsloekke")

str(llr)

llr$getFavorites(n=10)

# streaming
searchTwitter("regeringsgrundlag",n=10)
