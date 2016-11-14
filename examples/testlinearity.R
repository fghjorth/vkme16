require(ggplot2)

#sim data
df<-data.frame(x1=rnorm(1000,10,3))
df$x2<-2*df$x1+rnorm(1000,0,5)
df$x1round<-round(df$x1)

#plot
ggplot(df,aes(x1,x2)) + geom_point()

#imagine x1 is discrete
ggplot(df,aes(x1round,x2)) + geom_point()

#checking for linearity: jittering + loess fit
ggplot(df,aes(x1round,x2)) + geom_jitter() + geom_smooth(method="loess")
