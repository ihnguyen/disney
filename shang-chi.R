library("twitteR")
library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")
library("syuzhet")
library("ggplot2")
library("rtweet")
library("tidytext")
library("dplyr")
library("graphics")
library("purrr")
library("stringr")
library("textclean")

api_key <- "XXX"
api_secret <- "XXX"
access_token <- "XXX"
access_token_secret <- "XXX"
setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)

shang_tweet <- searchTwitter('shang-chi', n = 5000); head(shang_tweet)


tweetsdf <- twListToDF(shang_tweet)
write.csv(tweetsdf, file='ShangChi.csv')


myCorpus <- Corpus(VectorSource(tweetsdf$text),
                   readerControl = list(reader=readPlain,
                                        language="en"))

inspect(myCorpus[1:10])


myCorpus <- tm_map(myCorpus, removeWords, stopwords())
myCorpus <- tm_map(myCorpus, content_transformer(tolower))
myCorpus <- tm_map(myCorpus, content_transformer(removeNumbers))
myCorpus <- tm_map(myCorpus, stripWhitespace)
myCorpus <- tm_map(myCorpus, stemDocument)
remove_url <- function(x) gsub("http[^[:space:]]*","",x)
myCorpus <- tm_map(myCorpus,content_transformer(remove_url))
remove_at <- function(x) gsub("@\\w+", "", x)
myCorpus <- tm_map(myCorpus,content_transformer(remove_at))
remove_amp <- function(x) gsub("&amp", "", x)
myCorpus <- tm_map(myCorpus,content_transformer(remove_amp))
myCorpus <- tm_map(myCorpus, removeWords,c("amp", "ufef"))


dtm <- DocumentTermMatrix((myCorpus))
emotions <- get_nrc_sentiment(myCorpus$content)


barplot(colSums(emotions),cex.names = .7,
        col = rainbow(10),
        main = "Sentiment scores for Shang-Chi tweets"
)









