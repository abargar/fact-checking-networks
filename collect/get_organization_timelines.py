import tweepy
import json
import os

API_KEY = "wKRUBKs2u5fZjgrtBMBkwbC17"
API_SECRET_KEY = "aXYv16rBJEdhsrxikZtVBkmuSd0XYnL9487oOCYihyZklpdhHY"
TOKEN = "910692288183111680-JY95Kf6d1lEoPKO5Q1QV6uoxLIVT3VD"
TOKEN_SECRET = "U80ebhsII3aEHDYcvE8TTqOcX8nLoLcWKJ1yDj45X0V8X"

auth = tweepy.OAuthHandler(API_KEY, API_SECRET_KEY)
auth.set_access_token(TOKEN, TOKEN_SECRET)
api = tweepy.API(auth, wait_on_rate_limit=True)

TWEET_LIMIT = 1000
TIMELINE_FOLDER = "new_org_timelines"

if not os.path.exists(TIMELINE_FOLDER):
    os.makedirs(TIMELINE_FOLDER)
    
linenum = 1
with open("twitter_handles.csv", 'r') as fyle:
    for line in fyle.readlines():
        if linenum == 1:
            handle = line.rstrip()[1:]
            linenum += 1
        else:
            handle = line.rstrip()
        print(handle)
        handle_file = "{f}/{h}_9:10EST_07_10_2018.txt".format(f = TIMELINE_FOLDER, h = handle)
        with open(handle_file, 'a') as out:
            timeline_data = {}
            page = None
            for post in tweepy.Cursor(api.user_timeline,
                                      screen_name = handle,
                                      count = TWEET_LIMIT).items():
                post_str = json.dumps(post._json)
                print(post_str, file=out)
            
            
        
