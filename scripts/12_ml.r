> ###################################################
> # R code for "Big Data: New Tricks for Econometrics
> # Journal of Economic Perspectives 28(2), 3-28            
> # http://pubs.aeaweb.org/doi/pdfplus/10.1257/jep.28.2.3
> # Hal R. Varian
> ###################################################
> 
> # data is from http://biostat.mc.vanderbilt.edu/wiki/Main/DataSets
> dat <- read.csv("titanic3.csv")
> # remove missing data and extract variables
> titanic <- na.omit(dat[,c("survived","pclass","sex","age","sibsp")])
> survived <- titanic$survived
> surv <- survived
> surv[surv==0] <- "died"
> surv[surv==1] <- "lived"
> age <- titanic$age
> class <- titanic$pclass
> 
> # fit a simple tree
> library("rpart")
> model.rpart <- rpart(surv ~ class + age)
> model.prune <- prune(model.rpart,cp=.038)
> 
> # plot it
> library(rpart.plot)
> # Figure 1 in paper
> rpart.plot(model.prune,type=0,extra=2)
> # PDF plot
> pdf("titanic-age-class-plot.pdf")
> rpart.plot(model.prune,type=0,extra=2,cex=2)
> graphics.off()
> 
> # partition plot (Figure 2 in paper)
> n <- length(class)
> class.jitter <- class+.7*runif(n)
> plot(age ~ class.jitter,xlim=c(.95,3.8),cex=1.5,xlab="class",xaxt="n")
> axis(side=1,at=c(1.4,2.4,3.4),label=c("1st","2nd","3rd"))
> abline(v=1.85)
> abline(v=2.85)
> abline(h=16)
> points(age[survived==0] ~ class.jitter[survived==0],pch=4)
> rect(1.85,16,4.0,89,col=rgb(0.5,0.5,0.5,1/4))
> rect(2.85,-5,4.0,89,col=rgb(0.5,0.5,0.5,1/4))
> # PDF partition plot (for publication)
> pdf("titanic-partition-plot.pdf")
> plot(age ~ class.jitter,xlim=c(.95,3.8),cex=1.5,xlab="class",xaxt="n")
> axis(side=1,at=c(1.4,2.4,3.4),label=c("1st","2nd","3rd"))
> abline(v=1.85)
> abline(v=2.85)
> abline(h=16)
> points(age[survived==0] ~ class.jitter[survived==0],pch=4)
> rect(1.85,16,4.0,89,col=rgb(0.5,0.5,0.5,1/4))
> rect(2.85,-5,4.0,89,col=rgb(0.5,0.5,0.5,1/4))
> graphics.off()
> 