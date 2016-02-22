//
//  Tweet.swift
//  Twitter
//
//  Created by Che Chao Hsu on 2/9/16.
//  Copyright © 2016 Che Chao Hsu. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var id: Int
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var retweeted: Bool? = false
    var retweetCount: Int?
    var favorited: Bool? = false
    var favouritesCount: Int?
    
    init(dictionary: NSDictionary) {
        id = (dictionary["id"] as? Int)!
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        retweeted = dictionary["retweeted"] as? Bool
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favorited = dictionary["favorited"] as? Bool
        favouritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
}
