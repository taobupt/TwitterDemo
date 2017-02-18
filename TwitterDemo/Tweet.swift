//
//  Tweet.swift
//  TwitterDemo
//
//  Created by Tao Wang on 1/27/17.
//  Copyright © 2017 Tao Wang. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var text: String?
    var timestamp: String?
    var name: String?
    var retweetCount: Int=0
    var favoritesCount: Int=0
    var id1: Int64=0
    var profileUrl: String?
    var retweeted : Bool?
    var user: User?
    var dictionary: NSDictionary
    
    init(dictionray: NSDictionary){
        self.dictionary = dictionray
        user = User(dictionary: dictionray["user"] as! NSDictionary)
        text=dictionray["text"] as? String
        retweeted=dictionray["retweeted"] as? Bool
        id1 = (dictionray["id"] as? Int64) ?? 0
        retweetCount=(dictionray["retweet_count"] as? Int) ?? 0
        favoritesCount=(dictionray["favorite_count"] as? Int) ?? 0
        let timestampString=dictionray["created_at"] as? String
        let formatter=DateFormatter()
        formatter.dateFormat="EEE MMM d HH:mm:ss Z y"
        if let timestampString=timestampString{
            var times=formatter.date(from: timestampString)
            timestamp=formatter.string(from: times!)
        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        for dictionary in dictionaries{
            let tweet = Tweet(dictionray: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
}
