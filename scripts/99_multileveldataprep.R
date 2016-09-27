setwd("~/GitHub/vkme16")

require(haven)
require(magrittr)
require(readr)

nd<-read_dta("data/99_anes.dta")
nd[] <- lapply(nd, unclass)

#get labels data frame
labels<-nd %>%
  lapply(.,attr,which="label") %>%
  unlist() %>%
  as.data.frame()
labels<-labels %>% transmute(varname=rownames(labels),label=labels[,1])

nd2<-nd %>% 
  transmute(presvote=presvote2012_x,
            incgroup=incgroup_prepost_x,
            state=sample_state)

nd2$presvote[!(nd2$presvote %in% 1:2)]<-NA
nd2$incgroup[nd2$incgroup<0]<-NA

stateincs<-read_delim("C:/Users/kzc744/Dropbox/teaching/vkm_e16/data/stateincs.csv",delim=";",col_names=F)
abbs<-state.abb[match(stateincs$X1,state.name)]

si<-data.frame(state=abbs,stateinc=stateincs$X2)

nd2<-nd2 %>% 
  left_join(.,si,by="state")

write_dta(nd2,"data/4_anes.dta")
