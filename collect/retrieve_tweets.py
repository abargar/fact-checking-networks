import os
import pandas as pd
import tweepy
import json
from math import ceil

KEYS = dict(line.strip().split('=') for line in open('../twitter_keys.txt'))

auth = tweepy.OAuthHandler(KEYS['API_KEY'], KEYS['API_SECRET_KEY'])
auth.set_access_token(KEYS['TOKEN'], KEYS['TOKEN_SECRET'])
api = tweepy.API(auth)

filenames = [f.path for f in os.scandir("data/org_timelines_12_14_csvs/todo")]
filenames = [f for f in filenames if not f.endswith("_users.csv") and f.endswith(".csv")]

for f in filenames:
    print(f)
    json_file = "{0}.txt".format(f[:-4])
    id_strs = pd.read_csv(f, usecols=['id_str']).drop_duplicates()
    num_tweets = id_strs.shape[0]
    #print("Number of ids: {0}".format(num_tweets))
    tweet_jsons = []
    #num_rounds = ceil(num_tweets / 100)
    # print("Num rounds: {0}".format(ceil(num_tweets / 100)))
    num_found = 0
    #print(list(range(0,num_tweets-1,100)))
    for i in range(0,num_tweets-1,100):
        #print(min(i+100,num_tweets))
        select_tweets = id_strs.iloc[i:min(i+100,num_tweets)]
        select_tweets = select_tweets['id_str'].tolist()
        # print(i)
        with open(json_file, 'a') as outfile:
            for tweet in api.statuses_lookup(select_tweets,include_entities=True, tweet_mode='extended'):
                num_found += 1
                tweet_str = json.dumps(tweet._json)
                print(tweet_str, file=outfile)
    print("Number of ids found: {0} / {1}".format(num_found, num_tweets))
        
    
    
    
