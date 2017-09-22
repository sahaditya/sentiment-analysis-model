
setwd("D:/Rproject/New folder")
library(ggplot2)
library(tm)
library(wordcloud)
library(syuzhet)
#setwd("d:/Rproject")

texts<-readLines("pReview1.txt")

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
wordcloud(words = d$word, freq = d$freq, min.freq = 1, max.words = 100, random.order = FALSE, rot.per = 0.35, colors = brewer.pal(8,"Dark2"))
sentimentP1<-get_nrc_sentiment(texts)
#nserting in database. the freq of words of p1
m<-sentimentP1                                    #######
con<-mongo("SentiP1", url = "mongodb://localhost")#####
if(con$count()>0) con$drop                        #####
con$insert(m)                                     #####
#con$drop()                                       #####
######################################################
text<-cbind(texts,sentimentP1)

TotalsentimentP1<- data.frame(colSums(text[,c(2:11)]))
names(TotalsentimentP1)<-"count"
TotalsentimentP1<-cbind("sentimentP1"= rownames(TotalsentimentP1),TotalsentimentP1)
rownames(TotalsentimentP1)<-NULL

ggplot(data = TotalsentimentP1, aes(x = sentimentP1, y = count)) + geom_bar(aes(fill = sentimentP1), stat = "identity") + theme(legend.position = "none") + xlab("Sentiment") + ylab("Total count") + ggtitle("Total sentiment Score")
p1<-ggplot(data = TotalsentimentP1, aes(x = sentimentP1, y = count)) + geom_bar(aes(fill = sentimentP1), stat = "identity") + theme(legend.position = "none") + xlab("Sentiment") + ylab("Total count") + ggtitle("Total sentiment Score")
