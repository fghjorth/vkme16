require(haven)
require(dplyr)
require(janitor)

vu<-read_dta("2011Data.dta")

vur<-vu %>% 
  transmute(immthreat=convert_to_NA(as.numeric(V186),8:9),
            homeowner=ifelse(V330==1,1,0),
            hinc=convert_to_NA(as.numeric(V327),88:99),
            age=V367,
            female=V7-1,
            edu1=V341,
            edu2=V342,
            muninum=V363,
            region=V385,
            job=V376) %>% 
  mutate(hied=ifelse(edu2 %in% 7:10,1,0), #folk m. VU = 1
         hied=ifelse(edu1==3,1,hied)) #folk i gang med VU også = 1