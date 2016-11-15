setwd("~/GitHub/vkme16")

require(readr)
require(dplyr)
require(tidyr)

ed<-read_csv("data/11_enos.csv")

#ny df ed_did kun med de variable vi skal bruge
ed_did<-ed

#vi definerer 'treat' som dummy for at bo <500yrds fra demolition site
ed_did<-mutate(ed_did,treated=ifelse(demo.distance<500,1,0))

#udvælger treated samt turnout i 2000 og 2004
ed_did<-select(ed_did,treated,vote2000,vote2004) 

#konverter fra wide til long format
ed_did<-gather(ed_did,year,turnout,vote2000:vote2004)

#ny variabel 'post' som dummy for 2004
ed_did<-mutate(ed_did,post=ifelse(year=="vote2004",1,0))

#regressionsmodel
didmodel<-lm(turnout~post*treated,data=ed_did)
summary(didmodel)

#placebo test: vi goer alt det samme, bare med nondemodistance
ed_placebotest<-ed %>% 
  mutate(treated=ifelse(nondemo.distance<500,1,0)) %>% 
  select(treated,vote2000,vote2004) %>% 
  gather(year,turnout,vote2000:vote2004) %>% 
  mutate(post=ifelse(year=="vote2004",1,0))

placebomodel<-lm(turnout~post*treated,data=ed_placebotest)
summary(placebomodel)

#### PREPROCESSING

# ed<-read_csv("data.turnout.csv")
# glimpse(ed)
# ed$reg = as.Date(ed$reg)
# ed <- ed %>%
#   filter(reg<"2000-10-10" & !is.na(reg) & whitename>.95) %>%
#   mutate(treat=ifelse(demo.distance<=500,1,0)) %>%
#   select(vote1996:vote2004,demo.distance,nondemo.distance,context_black)
#write_csv(ed,"data/11_enos.csv")
