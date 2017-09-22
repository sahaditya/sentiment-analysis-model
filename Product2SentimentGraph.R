sentimentP2->y
Scorep2<-c(sum(x$anger),sum(x$anticipation),sum(x$disgust),sum(x$fear),sum(x$joy),sum(x$sadness),sum(x$surprise),sum(x$trust),sum(x$negative),sum(x$positive))
Sentisp2<-c("anger","anticipation","disgust","fear","joy","sadness","surprise","trust","negative","positive")
Totalp2<-c(56,56,56,56,56,56,56,56,56,56)
sentiScorep2<-data.frame(Sentisp2,Scorep2,Totalp2)
sentiScorep2
ggplot(sentiScorep2, aes(Sentisp2, y = Scorep2))+geom_histogram(aes(fill = Scorep2), stat = "identity")
#############################################
negativep2<-c("anger","disgust","fear","sadness","negative")
ouncep2 <- c(27,12,19,18,40)
founcep2<-c(100,100,100,100,100)
negSentip2<-data.frame(negativep2,ouncep2,founcep2)
negSentip2
l<-sum(negSentip2$ouncep2)
t<-sum(negSentip2$founcep2)
posiPercentp2<-((t-l)*100)/500
posiPercentp2