# Generated by Mochi Python compiler
from __future__ import annotations

import dataclasses
import typing

def newTwitter() -> Twitter:
	return Twitter(tweets={}, follows={}, time=0)

def postTweet(t: Twitter, userId: int, tweetId: int) -> Twitter:
	tweets = t.tweets
	_list = []
	if (userId in tweets):
		_list = tweets[userId]
	time = (t.time + 1)
	_list = ([Tweet(id=tweetId, time=time)] + _list)
	tweets[userId] = _list
	return Twitter(tweets=tweets, follows=t.follows, time=time)

def getNewsFeed(t: Twitter, userId: int) -> list[int]:
	all = []
	if (userId in t.tweets):
		all = (all + t.tweets[userId])
	if (userId in t.follows):
		for f in t.follows[userId]:
			if (f in t.tweets):
				all = (all + t.tweets[f])
	_sorted = [ tw for tw in sorted([ tw for tw in all ], key=lambda tw: (-tw.time)) ]
	feed = []
	i = 0
	while ((i < len(_sorted)) and (i < 10)):
		t = _sorted[i]
		feed = (feed + [t.id])
		i = (i + 1)
	return feed

def follow(t: Twitter, followerId: int, followeeId: int) -> Twitter:
	follows = t.follows
	_set = {}
	if (followerId in follows):
		_set = follows[followerId]
	_set[followeeId] = True
	follows[followerId] = _set
	return Twitter(tweets=t.tweets, follows=follows, time=t.time)

def unfollow(t: Twitter, followerId: int, followeeId: int) -> Twitter:
	follows = t.follows
	if (followerId in follows):
		_set = follows[followerId]
		if (followeeId in _set):
			_set = removeKey(_set, followeeId)
			follows[followerId] = _set
	return Twitter(tweets=t.tweets, follows=follows, time=t.time)

def removeKey(m: dict[int, bool], k: int) -> dict[int, bool]:
	out = {}
	for key in m:
		if (key != k):
			out[key] = m[key]
	return out

@dataclasses.dataclass
class Tweet:
	id: int
	time: int

@dataclasses.dataclass
class Twitter:
	tweets: dict[int, list[Tweet]]
	follows: dict[int, dict[int, bool]]
	time: int

def example():
	tw = newTwitter()
	tw = postTweet(tw, 1, 5)
	assert (getNewsFeed(tw, 1) == [5])
	tw = follow(tw, 1, 2)
	tw = postTweet(tw, 2, 6)
	assert (getNewsFeed(tw, 1)[0:2] == [6, 5])
	tw = unfollow(tw, 1, 2)
	assert (getNewsFeed(tw, 1) == [5])

def empty_feed():
	tw = newTwitter()
	assert (getNewsFeed(tw, 1) == [])

def multiple_tweets():
	tw = newTwitter()
	tw = postTweet(tw, 1, 101)
	tw = postTweet(tw, 1, 102)
	assert (getNewsFeed(tw, 1) == [102, 101])

def main():
	example()
	empty_feed()
	multiple_tweets()

if __name__ == "__main__":
	main()
