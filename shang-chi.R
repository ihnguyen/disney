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

api_key <- "moMqwahI89bouu0N4S2o39jg7"
api_secret <- "DShXkahhV3thrXirN1YWlkigPAQfqXqLaKhZpyAbfNkhGfzNOF"
access_token <- "1461864624395993097-zSiD41FRzeyO4Y17NfOvl5t3gUJATT"
access_token_secret <- "ysK99HYNkY9j3XQ982YeDuY6nnp3YXUzG4jsQ3nTBYaZV"
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









