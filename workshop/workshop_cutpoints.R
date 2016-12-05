ebtest<-readRDS("~/GitHub/vkme16/midterm/midtermdata.rds")

#midterm opg 10

#10
ebtest$income_lohi<-ifelse(ebtest$income>6,1,0) #dichotomous income var
nomatchvars<-c("catholicpct","cntryname","nation2","income","membrshp","income_lohi","regionat")
set.seed(123)
ebr<-sample_frac(ebtest,.05)
imbalance(ebr$income_lohi,ebr,drop=nomatchvars)
ebmatch<-cem("income_lohi",ebr,drop=nomatchvars)
imbalance(ebr[ebmatch$matched,]$income_lohi,ebr[ebmatch$matched,],drop=nomatchvars)
ols3fer<-lm(membrshp~income+age+sex+educ+lrs+factor(nation2)+factor(year),data=ebr)
ols3ferm<-lm(membrshp~income+age+sex+educ+lrs+factor(nation2)+factor(year),data=ebr[ebmatch$matched,])
stargazer(ols3fer,ols3ferm,type="text")

#bedre matching
#hvilke variable matcher vi på?
names(ebr)[!(names(ebr) %in% nomatchvars)]

glimpse(ebr)
ebcutpoints<-list(year=c(1970,1980,1990,2000),
                  age=c(20,40,60,80),
                  sex=1.5,
                  educ=c(1.5,4.5,7.5,9.5),
                  lrs=c(2.5,5.5,8.5),
                  matpmat=c(1.5,2.5))

ebmatch2<-cem("income_lohi",ebr,drop=nomatchvars,cutpoints=ebcutpoints)
ebmatch2
imbalance(ebr[ebmatch2$matched,]$income_lohi,ebr[ebmatch2$matched,],drop=nomatchvars)
