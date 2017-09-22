sentimentP3->z
Scorep3<-c(sum(x$anger),sum(x$anticipation),sum(x$disgust),sum(x$fear),sum(x$joy),sum(x$sadness),sum(x$surprise),sum(x$trust),sum(x$negative),sum(x$positive))
Sentisp3<-c("anger","anticipation","disgust","fear","joy","sadness","surprise","trust","negative","positive")
Totalp3<-c(56,56,56,56,56,56,56,56,56,56)
sentiScorep3<-data.frame(Sentisp3,Scorep3,Totalp3)
sentiScorep3
ggplot(sentiScorep3, aes(Sentisp3, y = Scorep3))+geom_histogram(aes(fill = Scorep3), stat = "identity")
#############################################
negativep3<-c("anger","disgust","fear","sadness","negative")
ouncep3 <- c(27,12,19,18,40)
founcep3<-c(43,43,43,43,43)
negSentip3<-data.frame(negativep3,ouncep3,founcep3)
negSentip3
l<-sum(negSentip3$ouncep3)
t<-sum(negSentip3$founcep3)
posiPercentp3<-((t-l)*100)/215
posiPercentp3