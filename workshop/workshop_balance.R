require(dplyr)
require(Matching)

set.seed(5678)

expdat<-data.frame(treat=sample(0:1,1000,replace=T),
                   x1=rnorm(1000),
                   x2=rnorm(1000),
                   x3=rnorm(1000),
                   x4=rnorm(1000))

mb<-MatchBalance(treat~x1+x2+x3+x4,data=expdat)

#træk alle t-test p-værdierne ud
sapply(mb$BeforeMatching,function(x){ x$p.value })
