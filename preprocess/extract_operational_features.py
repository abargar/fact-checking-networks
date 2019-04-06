import json
import csv
import os
from datetime import datetime, timedelta
from email.utils import parsedate_tz

# sentiment?
# number of followers
# presence of visual/audiovisual
## presence of image
## presence of video
# presence of url
# age of account
# past level of popularity
# past level of activity (user.statuses_count)
# text is included to permit other coding

data_dir = "data/stream_12_14_15/"
datafiles = [f.name for f in os.scandir(data_dir)]

feature_headers = ["ID", "userID", "screen_name", 
               "followers_count", "has_image", "has_video", "has_gif", "has_url",
               "account_age_days", "statuses_count", "text", 'retweeted',
                   'quoted']
res_headers = ['favorite_count', 'retweet_count','quote_count']
out_headers = feature_headers + res_headers

def processAllTweets(tweet, writer):
    try:
        fVector = extractFeatureVector(tweet)
        writer.writerow(fVector)
        if fVector['retweeted']:
            retweet = tweet.get("retweeted_status")
            processAllTweets(retweet, writer)
        if fVector['quoted']:
            quote = tweet.get("quoted_status")
            processAllTweets(quote, writer)
    except Exception as e:
        print(e)
    

def extractFeatureVector(tweet):
    fVector = { header: None for header in out_headers }
    # IDENTIFIERS
    fVector['ID'] = tweet['id_str']
    user = tweet['user']
    fVector['userID'] = user['id_str']
    fVector['screen_name'] = user['screen_name']
    # USER ATTRIBUTES
    fVector['followers_count'] = user['followers_count']
    fVector['statuses_count'] = user['statuses_count']
    # account age
    user_age = parsedate_tz(user['created_at'])
    user_age_dt = datetime(*user_age[:6])
    tweet_age = parsedate_tz(tweet['created_at'])
    tweet_age_dt = datetime(*tweet_age[:6])
    fVector['account_age_days'] = (tweet_age_dt - user_age_dt).days
    # TWEET ATTRIBUTES
    # TODO: handle truncated tweet
    truncated = tweet.get("truncated") is True
    #fVector['text'] = tweet['text']
    if truncated:
        #print(tweet.get('truncated'))
        full_tweet = tweet.get('extended_tweet')
        #print(full_tweet.keys())
        fVector['text'] = full_tweet.get('full_text')
    else:
        # print(tweet.keys())
        fVector['text'] = tweet['text']
    entities = tweet.get("entities")
    if entities:
        # TODO: these may need to match the retweeted or quoted tweet
        fVector['has_url'] = len(entities['urls']) > 0
        media = entities.get('media')
        if media is not None and len(media) > 0:
            fVector['has_image'] = any([m['type'] == 'photo' for m in media])
            fVector['has_video'] = any([m['type'] == 'video' for m in media])
            fVector['has_gif'] = any([m['type'] == 'animatedgif' for m in media])
            
    extended_entities = tweet.get('extended_entities')
    if extended_entities:
        media = extended_entities.get("media")
        fVector['has_image'] = any([m['type'] == 'photo' for m in media]) or fVector['has_image']
        fVector['has_video'] = any([m['type'] == 'video' for m in media]) or fVector['has_video']
        fVector['has_gif'] = any([m['type'] == 'animatedgif' for m in media]) or fVector['has_gif']
        urls = extended_entities.get('urls')
        if urls:
            fVector['has_url'] = len(urls) > 0
    else:
        fVector['has_image'] = False
        fVector['has_video'] = False
        fVector['has_gif'] = False
    # RELATIONAL
    if tweet.get("retweeted_status") is not None:
        fVector['retweeted'] = True
    else:
        fVector['retweeted'] = False
    if tweet.get("quoted_status") is not None:
        fVector['quoted'] = True
    else:
        fVector['quoted'] = False
    # RESULTS
    fVector['favorite_count'] = tweet['favorite_count']
    fVector['retweet_count'] = tweet['retweet_count']
    fVector['quote_count'] = tweet.get('quote_count')
    return fVector

#temp variable
for f in datafiles:
    fpath = "{0}{1}".format(data_dir,f)
    print(fpath)
    respath = "results/{0}.csv".format(f[:-4])
    with open(fpath, 'r') as input_file:
        with open(respath, 'w') as out_file:
            counter = 0
            writer = csv.DictWriter(out_file, fieldnames=out_headers)
            writer.writeheader()
            for line in input_file.readlines():
                try:
                    tweet = json.loads(line)
                    processAllTweets(tweet, writer)
                    counter += 1
                except Exception as e:
                    print(e)
                    break
        print(counter)
