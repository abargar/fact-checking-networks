library(ggplot2)

csv_folder <- "org_timelines_csvs_07_10_2018/"
timeline_files <- dir(csv_folder, pattern="*2018.csv")
#columns
name = c()
num_tweets = c()
num_quotes = c()
num_retweets = c()
num_replies = c()
num_links = c()
num_media = c()

for(file in timeline_files){
  timeline <- read.csv(paste(csv_folder,file, sep=""), stringsAsFactors = FALSE)
  name <- c(name, as.character(sub("_.*", "", file)))
  num_tweets <- c(num_tweets, nrow(timeline))
  num_quotes <- c(num_quotes, sum(timeline$is_quote_status == "True"))
  num_retweets <- c(num_retweets, sum(timeline$retweeted == "True"))
  num_replies <- c(num_replies, sum(! is.na(timeline$in_reply_to_user_id)))
  num_links <- c(num_links, sum(timeline$urls != "[]"))
  num_media <- c(num_media, sum(timeline$media != "[]"))
}
summary_df <- data.frame(name = name,
                         num_tweets = num_tweets, 
                         num_quotes = num_quotes, 
                         num_retweets = num_retweets,
                         num_replies = num_replies,
                         num_links = num_links,
                         num_media = num_media,
                         stringsAsFactors = FALSE
)