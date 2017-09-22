#Sentiment graph for product 1 ######

sentimentP1->x
Scorep1<-c(sum(x$anger),sum(x$anticipation),sum(x$disgust),sum(x$fear),sum(x$joy),sum(x$sadness),sum(x$surprise),sum(x$trust),sum(x$negative),sum(x$positive))
Sentisp1<-c("anger","anticipation","disgust","fear","joy","sadness","surprise","trust","negative","positive")
Totalp1<-c(56,56,56,56,56,56,56,56,56,56)
sentiScorep1<-data.frame(Sentisp1,Scorep1,Totalp1)
ggplot(sentiScorep1, aes(Sentisp1, y = Scorep1))+geom_histogram(aes(fill = Scorep1), stat = "identity")
#############################################
negativep1<-c("anger","disgust","fear","sadness","negative")
ouncep1 <- c(9,3,8,7,17)
founcep1<-c(56,56,56,56,56)
negSentip1<-data.frame(negativep1,ouncep1,founcep1)
negSentip1
l<-sum(negSentip1$ouncep1)
t<-sum(negSentip1$founcep1)
posiPercentp1<-((t-l)*100)/280
posiPercentp1
##################################################
