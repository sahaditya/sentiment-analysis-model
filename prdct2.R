library(ggplot2)
library(tm)
library(wordcloud)
library(syuzhet)
setwd("D:/Rproject/New folder")
texts<-readLines("pReview2.txt")

docs<-Corpus(VectorSource(texts))
trans<-content_transformer(function(x,pattern) gsub(pattern," ", x))
docs<-tm_map(docs,trans,"/")
docs<-tm_map(docs,trans,",")
docs<-tm_map(docs,trans,"\\|")
docs<-tm_map(docs,content_transformer(tolower))
docs<-tm_map(docs,removeNumbers)
docs<-tm_map(docs,removeWords,stopwords("english"))
docs<-tm_map(docs,removePunctuation)
docs<-tm_map(docs,stripWhitespace)
docs<-tm_map(docs,stemDocument)

dtm<-TermDocumentMatrix(docs)
mat<-as.matrix(dtm)
v<-sort(rowSums(mat),decreasing = TRUE)

d<-data.frame(word = names(v), freq = v)
head(d,10)

set.seed(1056)
wordcloud(words = d$word, freq = d$freq, min.freq = 1, max.words = 200, random.order = FALSE, rot.per = 0.35, colors = brewer.pal(8,"Dark2"))

sentimentP2<-get_nrc_sentiment(texts)
#inserting in database. the freq of words of p2
m<-sentimentP2                                    #######
con<-mongo("SentiP2", url = "mongodb://localhost")#####
if(con$count()>0) con$drop                        #####
con$insert(m)                                     #####
#con$drop()                                       #####
######################################################
text<-cbind(texts,sentimentP2)

TotalsentimentP2<- data.frame(colSums(text[,c(2:11)]))
names(TotalsentimentP2)<-"count"
TotalsentimentP2<-cbind("sentimentP2"= rownames(TotalsentimentP2),TotalsentimentP2)
rownames(TotalsentimentP2)<-NULL

ggplot(data = TotalsentimentP2, aes(x = sentimentP2, y = count)) + geom_bar(aes(fill = sentimentP2), stat = "identity") + theme(legend.position = "none") + xlab("Sentiment") + ylab("Total count") + ggtitle("Total sentiment Score")
p2<-ggplot(data = TotalsentimentP2, aes(x = sentimentP2, y = count)) + geom_bar(aes(fill = sentimentP2), stat = "identity") + theme(legend.position = "none") + xlab("Sentiment") + ylab("Total count") + ggtitle("Total sentiment Score")

