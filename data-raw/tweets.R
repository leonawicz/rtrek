library(rtweet)
library(dplyr)
source("data-raw/keys.R") # untracked
source("data-raw/utils.R")
create_token(app = keys$app, consumer_key = keys$consumer_key, consumer_secret = keys$consumer_secret,
             access_token = keys$access_token, access_secret = keys$access_secret)

sondow <- c("PicardTips", "WorfEmail", "RikerGoogling", "LocutusTips", "GuinanTips",
            "WesleyTips", "Data_Tips", "RikerTips", "WorfTips", "LaForgeTips")
users_ds9 <- c("AnnoyedOBrien", "ColNerys", "RealElimGarak", "realRealDukat", "realGulDukat", "Odo_constable", "itsvicfontaine")
tweet_dir <- "data-raw/tweet-data"
tweetfile <- file.path(tweet_dir, c("tngtweets.rds", "ds9tweets.rds"))
jsonfile <- file.path(tweet_dir, c("tngtweets.json", "ds9tweets.json",
                                   "tngtweets_cleaned.json", "ds9tweets_cleaned.json"))

tng <- update_local_tweets(sondow, tweetfile[1])
ds9 <- update_local_tweets(users_ds9, tweetfile[2])

tng2 <- select(tng, 4:5)
ds92 <- select(ds9, 4:5)
tng2_cleaned <- tame_tweets(tng2)
ds92_cleaned <- tame_tweets(ds92, accounts = users_ds9)

dn <- group_by(ds92_cleaned, screen_name) %>% count()
dn

set.seed(47)
ds92_cleaned2 <- filter(ds92_cleaned, screen_name != "realGulDukat") %>% group_by(screen_name) %>%
  sample_n(dn$n[dn$screen_name == "realRealDukat"], replace = TRUE) %>% distinct() %>%
  mutate(text = gsub("&amp;", "&", text))

tng_json <- jsonlite::toJSON(tng2)
ds9_json <- jsonlite::toJSON(ds92)
tng2_cleaned_json <- jsonlite::toJSON(tng2_cleaned)
ds92_cleaned_json <- jsonlite::toJSON(ds92_cleaned2)

sink(file = jsonfile[1]); cat(tng_json); sink()
sink(file = jsonfile[2]); cat(ds9_json); sink()
sink(file = jsonfile[3]); cat(tng2_cleaned_json); sink()
sink(file = jsonfile[4]); cat(ds92_cleaned_json); sink()
