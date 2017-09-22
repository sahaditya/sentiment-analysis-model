library(ggplot2)
library(tm)
library(wordcloud)
library(syuzhet)
setwd("D:/Rproject/New folder")
texts<-readLines("pReview3.txt")

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

sentimentP3<-get_nrc_sentiment(texts)
#inserting in database. the freq of words of p3
m<-sentimentP3                                    #######
con<-mongo("SentiP3", url = "mongodb://localhost")#####
if(con$count()>0) con$drop                        #####
con$insert(m)                                     #####
#con$drop()                                       #####
######################################################
text<-cbind(texts,sentimentP3)

TotalsentimentP3<- data.frame(colSums(text[,c(2:11)]))
names(TotalsentimentP3)<-"count"
TotalsentimentP3<-cbind("sentimentP3"= rownames(TotalsentimentP3),TotalsentimentP3)
rownames(TotalsentimentP3)<-NULL

ggplot(data = TotalsentimentP3, aes(x = sentimentP3, y = count)) + geom_bar(aes(fill = sentimentP3), stat = "identity") + theme(legend.position = "none") + xlab("Sentiment") + ylab("Total count") + ggtitle("Total sentiment Score")
p3<-ggplot(data = TotalsentimentP3, aes(x = sentimentP3, y = count)) + geom_bar(aes(fill = sentimentP3), stat = "identity") + theme(legend.position = "none") + xlab("Sentiment") + ylab("Total count") + ggtitle("Total sentiment Score")
