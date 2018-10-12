import tweepy
import json
import pandas as pd

API_KEY = "wKRUBKs2u5fZjgrtBMBkwbC17"
API_SECRET_KEY = "aXYv16rBJEdhsrxikZtVBkmuSd0XYnL9487oOCYihyZklpdhHY"
TOKEN = "910692288183111680-JY95Kf6d1lEoPKO5Q1QV6uoxLIVT3VD"
TOKEN_SECRET = "U80ebhsII3aEHDYcvE8TTqOcX8nLoLcWKJ1yDj45X0V8X"

auth = tweepy.OAuthHandler(API_KEY, API_SECRET_KEY)
auth.set_access_token(TOKEN, TOKEN_SECRET)
api = tweepy.API(auth, wait_on_rate_limit=True)

with open("twitter_handle_info.json", 'a') as out:
    with open("twitter_handles.csv", 'r') as fyle:
        fyle.readline() # ignore header
        for handle in fyle.readlines():
            data = api.get_user(screen_name=handle)
            data_str = json.dumps(data._json)
            print(data_str, file=out)

user_info = pd.read_json("twitter_handle_info.json", lines=True)
user_info['profile_location'] = user_info['profile_location'].apply(lambda x:  x.get('full_name') if x is not None else None)
user_info['url'] = user_info['entities'].apply(lambda x: x.get("url").get("urls")[0].get("expanded_url") if x is not None else None)
user_info = user_info[[ "id_str", "screen_name", "created_at", "description", "favourites_count", "followers_count", "friends_count", "geo_enabled",  "has_extended_profile", "is_translation_enabled", "lang", "listed_count", "location", "name", "profile_image_url",	"profile_location", "protected", "statuses_count", "time_zone", "url", "utc_offset", "verified"]]
user_info.to_csv("twitter_handle_info.csv", index=False)
