#Download the R package that allows us to pull tweets into your local R session
install.packages("twitteR") 
install.packages("rtweet")
install.packages("maps") 
install.packages("ggmap") 
install.packages(c('ROAuth','RCurl'))
install.packages("RColorBrewer")
install.packages("NLP")
install.packages("sentimentr")
install.packages("topicmodels")
library(twitteR)
library(rtweet)
library(ggplot2)
library(dplyr)
library(tidytext)
library(maps)
library(ggmap)
library(ROAuth)
library(RCurl)

library('tm') # text mining
library("stringi") 
library("stringr")
library('RColorBrewer')
library('wordcloud')
library(igraph)
library("sentimentr")

library(topicmodels)
library(tidyverse) 
library(rvest) 
library(reshape2)
library(data.table)


#Certification schemes for Internet transfers
download.file(url="http://curl.haxx.se/ca/cacert.pem",
              destfile="C:\\Users\\suki9\\Downloads\\study in France\\course\\UE 2  Big Data Analytics\\Advanced Social Media Analytics\\project\\cacert.pem")
              

#Create R objects from your own consumer information
my.key<-"kryacTaU7It4LwRfq2Asj8MbN" 
my.secret<-"ojK3hoRt0d08Qg2CHgAD8qZmGayulcqBAIvhdawvXHH6AJsvCz" 
aces_token<-"1318162801341435904-LmZ8mcTK0gw9rnMUHjeEhUYsFz9IP4" 
access_secret<-"yrbxDqOI9hwkDh5d4g52iY6gjfOm6yMvdSijcG4Ccx2RD"

#Authentication process
setup_twitter_oauth(my.key, my.secret, aces_token, access_secret)
Yes

#Obtaining Twitter data into a list
PS5data<-search_tweets("Playstation 5 OR PlayStation 5 OR playstation5 OR PS5 OR PS5Share OR ps5",
                       n=5000)
fwrite(PS5data, file ="ps5.csv")

class(PS5data)
head(PS5data, n = 2)

PS5data <- read_csv('ps5.csv')


#how many locations are represented
length(unique(PS5data$location))

#Removing special characters in non latin language
PS5data$location2<-iconv(PS5data$location, to = "ASCII", sub="")

#Let’s remove those with na.omit()
PS5data$location2[PS5data$location2==""] <- NA 
PS5data$location2[PS5data$location2==", "] <- NA
PS5data$location2[PS5data$location2==" "] <- NA
PS5data$location2[PS5data$location2=="  "] <- NA

#Twitter users - unique locations
PS5data %>%count(location2, sort=TRUE) %>% 
  mutate(location2=reorder(location2,n)) %>% 
  na.omit()%>% 
  top_n(10)%>%
  ggplot(aes(x=location2,y=n))+ 
  geom_bar(stat="identity")+geom_col()+coord_flip() + 
  labs(x = "Location", y = "Count",title = "Twitter users - unique locations ")+
  theme_light()


#generate function

#Twitter users - unique locations

## plot time series of tweets 
ts_plot(PS5data, "hours")+
  ggplot2::theme_minimal()+ 
  ggplot2::theme(plot.title=ggplot2::element_text(face="bold"))+ 
  ggplot2::labs(x=NULL,y=NULL,
                title="Frequency of PS5 Twitter statuses", 
                subtitle="Twitter status counts 1-hour intervals", 
                caption="\nSource: Data collected from Twitter's API"   
  )

#Corpus creation and data cleaning
# Removing special characters in non latin language
usableText <- iconv(PS5data$text, to = "ASCII", sub="")
PS5data_corpus<-Corpus(VectorSource(usableText)) 

PS5data_corpus<-tm_map(PS5data_corpus,tolower) 
PS5data_corpus<-tm_map(PS5data_corpus, removePunctuation) 
PS5data_corpus<-tm_map(PS5data_corpus,removeNumbers) 
PS5data_corpus<-tm_map(PS5data_corpus,removeWords, stopwords("en"))      

# Inspect output
writeLines(as.character(PS5data_corpus[[10]]))


#remove useless words (ex:"Macron","France")
useless_word <- c("playstation","httpstcoyisgomrp","httpstcodbqnazjpi","httpstcopowpebuqz","just","can","will","get","dont","still", "amp","via")

PS5data_corpus<-tm_map(PS5data_corpus,function(x)removeWords(x, useless_word))
text_corpus <- tm_map(PS5data_corpus,content_transformer(function(x) iconv(x,to='ASCII',sub='byte')))

# Stemming (may not be usedful)
library(SnowballC)


# Hastag
Hastags <- ps5_table_data %>% 
  select(Hastags) %>% 
  gsub("\\|", " ", Hastags, fixed=TRUE) #%>%
#apply(Hastags,str_replace(Hastags, "|", " ")) %>%
#strsplit(Hastags, "|") %>%
group_by(Hastags) %>%
  summarize(count=n())
Hastags <- subset(Hastags, count > 10)



# Stem document
PS5data_corpus <- tm_map(PS5data_corpus, stemDocument)

# The document-term matrix
PS5data.tdm <- TermDocumentMatrix(text_corpus) 
m <- as.matrix(PS5data.tdm)
m[1:2,1:10]

# length = total number of terms
length(rowSums(as.matrix(PS5data.tdm)))


#Most frequent terms in our matrix
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v) 
head(d, 30)

# remove very frequent words and very rare words (coz not descriptive to a particular topic)
dtmr <- DocumentTermMatrix(PS5data_corpus, control = list(wordLengths = c(4,20), bounds = list(global= c(3,27))))


#Word Frequency
barplot(d[1:20,]$freq, las = 3,
        names.arg = d[1:20,]$word,col ="lightblue", main ="Most frequent words",
        ylab = "Word frequencies")

#Identify terms used at least 50 times
findFreqTerms(PS5data.tdm, lowfreq=50)[1:10]


# correlation
findAssocs(PS5data.tdm, "sony", 0.4)

#Wordcloud
wordcloud(words = d$word, freq = d$freq, min.freq = 40,
          max.words=100, random.order=FALSE,
          colors=brewer.pal(4,"Dark2"))

#Remove sparse terms from the term-document matrix
PS5data.tdm<-removeSparseTerms(PS5data.tdm, sparse=0.95)

#Convert the term-document matrix to a data frame
PS5data.df <- as.data.frame(as.matrix(PS5data.tdm))

#scale(standardization) the data since clustering is sensitive to the scale of the data used
PS5data.df.scale <- scale(PS5data.df)

#Create the distance matrix: each cell represents the distance between each pair of documents/tweets
PS5data.dist <- dist(PS5data.df.scale, method = "euclidean")

#Cluster the data: tweets are grouped into classes
PS5data.fit<-hclust(PS5data.dist, method="ward.D2")

#Visualize the result
plot(PS5data.fit, main="Cluster-PS5")

#Plotting clusters
groups <- cutree(PS5data.fit, k=4) 
plot(PS5data.fit, main="Cluster-PS5") 
rect.hclust(PS5data.fit, k=4, border="red")


#Relationships Between Hashtags

#Define a tag extractor function
tags<-function(x) toupper(grep("#",strsplit(x, " +")[[1]],value=TRUE))

#Create a list of tag sets for each tweet
l <- nrow(PS5data)
taglist <- vector(mode = "list", l)

# Create an empty vector to store the tweet texts
texts <- vector(mode = "character", length = l)

#Extract the tweet text from each tweet status
for (i in 1:l) texts[i] <- PS5data$text[i]
texts <- iconv(texts, to = "ASCII", sub="") 

# ... and populate it
j<-0
for(i in 1:l){
  if(is.na(str_match(texts[i],"#"))[1,1]==FALSE){
    j<-j+1
    taglist[[j]]<-str_squish(removePunctuation(tags(ifelse(is.na(str_match(texts[i],"[\n]")[1,1])==TRUE,texts[i],gsub("[\n]"," ",texts[i])))))
  }
}
alltags <- NULL
for (i in 1:l) alltags<-union(alltags,taglist[[i]])

#Create an empty graph
hash.graph <- graph.empty(directed = T)

# Populate it with nodes
hash.graph <- hash.graph + vertices(alltags)

#Populate it with edges
for (tags in taglist){
  if (length(tags)>1){
    for (pair in combn(length(tags),2,simplify=FALSE,
                       FUN=function(x) sort(tags[x]))){
      if (pair[1]!=pair[2]) {
        if (hash.graph[pair[1],pair[2]]==0)
          hash.graph<-hash.graph+edge(pair[1],pair[2])
      }
    }
  }
}

#Network construction
V(hash.graph)$color <- "black"
E(hash.graph)$color <- "black"
V(hash.graph)$name <- paste("#",V(hash.graph)$name,sep = "") 
V(hash.graph)$label.cex = 0.75
V(hash.graph)$size <- 20
V(hash.graph)$size2 <- 2 
hash.graph_simple<-delete.vertices(simplify(hash.graph),degree(hash.graph)<=10)

#Network construction
plot(hash.graph_simple, edge.width = 2,
     edge.color = "black", 
     vertex.color = "SkyBlue2", 
     vertex.frame.color="black", 
     label.color = "black", 
     vertex.label.font=2, 
     edge.arrow.size=0.5)

#Sentiment Analysis
plain.text<-vector()
for(i in 1:dim(PS5data)[1]){
  plain.text[i]<-PS5data_corpus[[i]][[1]] }
sentence_sentiment<-sentiment(get_sentences(plain.text)) 
sentence_sentiment

average_sentiment <- mean(sentence_sentiment$sentiment)
average_sentiment

sd_sentiment<-sd(sentence_sentiment$sentiment) 
sd_sentiment

#Confidence Interval(CI)=[average-1.96*sd/sqrt(sample size); average+1.96*sd/sqrt(sample size)]
average_sentiment-1.96*sd_sentiment/sqrt(2861)
average_sentiment+1.96*sd_sentiment/sqrt(2861)

#Sentiment terms
extract_sentiment_terms(get_sentences(plain.text))


#Topic Modeling

text_corpus2<-text_corpus[1:200] 
doc.lengths<-rowSums(as.matrix(DocumentTermMatrix(text_corpus2)))
dtm <- DocumentTermMatrix(text_corpus2[doc.lengths > 0])

# Pick a random seed for replication
SEED = sample(1:1000000, 1)
# Let's start with 4 topics
k=7

Topics_results<-LDA(dtm, k = k, control = list(seed = SEED))

terms(Topics_results,15)

topics(Topics_results)

# What words contribute to the topic
tidy_model_beta<-tidy(Topics_results, matrix = "beta")

tidy_model_beta %>% group_by(topic) %>% top_n(10, beta) %>% ungroup() %>% arrange(topic, -beta) %>% 
  ggplot(aes(reorder(term, beta),beta,fill=factor(topic))) + geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") + scale_fill_viridis_d() +
  coord_flip() + labs(x = "Topic",
                      y = "beta score",
                      title = "Topic modeling")

# Gamma 
# gamma probabilty is the probability of a document belongs to a topic
tidy_model_gamma <- tidy(Topics_results, matrix= 'gamma')

ggplot(tidy_model_gamma, aes(gamma, fill = as.factor(topic)))+
         geom_histogram(show.legend = FALSE) + facet_wrap(~topic, ncol = 3)

       