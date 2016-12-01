setwd("~/GitHub/vkme16/")

require(rvest)
require(dplyr)
require(magrittr)

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
#her bruger vi extract2() fra magrittr til at vælge de rigtige
kr1<-extract2(kr,14)

#gemmer som tabel
kr1<-html_table(kr1,fill=T)

#vi gemmer de andre på samme måde og samler
kr2<-html_table(extract2(kr,15),fill=T)
kr3<-html_table(extract2(kr,16),fill=T)

#samler alle tre
kr_all<-bind_rows(kr1,kr2,kr3)

#fjerner ekstra rækker
kr_all<-filter(kr_all,Navn!="Navn")

#det hele kan gøres meget mere kompakt med piping
#træk data ud fra wiki-tabellen
kr<-krurl %>% 
  read_html() %>% 
  html_nodes("table") %>% 
  extract2(14) %>% 
  html_table()

###
# DEL 2: API'ER
###
