//
//  TwitterClient.swift
//  Twitter
//
//  Created by Che Chao Hsu on 2/8/16.
//  Copyright © 2016 Che Chao Hsu. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterConsumerKey = "Gq1W4hAphIrq2cHUv7bSUwQn1"
let twitterConsumerSecret = "dbOPpLImNplIb2ICU08iVgSdp9Mgqt9HhZPcw0ACo7R01I5sMa"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {
    
    var loginCompletion: ((user:User?, error: NSError?) -> ())?
    
    // property name sharedInstance, type TwitterClient
    class var sharedInstance: TwitterClient {
        // Since no stored properties
        struct Static {
            // Production would be in p-list
            static let instance =
            TwitterClient(baseURL: twitterBaseURL,
                          consumerKey: twitterConsumerKey,
                          consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET(
            "1.1/statuses/home_timeline.json",
            parameters: params,
            success: { (operation: NSURLSessionDataTask?, response: AnyObject?) -> Void in
                //                    print("home timeline: \(response!)")
                var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                
                for tweet in tweets {
                    print("text: \(tweet.text), created: \(tweet.createdAt)")
                    
                }
                completion(tweets: tweets, error: nil)
            },
            failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error getting home timeline")
                completion(tweets: nil, error: error)
                
        })
    }
    
    // Initate login process. If succeeds or fails, call the completion block user or error
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        // Fetch request token & redirect to authorization page
        // Clean before getting going
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        // Implies signed-out, problem if timing off
        TwitterClient.sharedInstance.fetchRequestTokenWithPath(
            "oauth/request_token",
            method: "GET",
            callbackURL: NSURL(string: "cchtwitter://oauth"),
            scope: nil,
            success: {
                (requestToken: BDBOAuth1Credential!) -> Void in
                print("Got the request token")
                var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
                // Handle to singleton app, could open app, app then decides routing
                UIApplication.sharedApplication().openURL(authURL!)
            }) {
                (error: NSError!) -> Void in
                print("Failed to get request token")
                self.loginCompletion?(user: nil, error: error)

        }
    }
    
    func openURL(url: NSURL) {
        // Because I'm in the function, no need to call TwitterClient.sharedInstance.
        fetchAccessTokenWithPath(
            "oauth/access_token",
            method: "POST",
            requestToken: BDBOAuth1Credential(queryString: url.query),
            success: { (accessToken: BDBOAuth1Credential!) -> Void in
                print("Got the access token")
                // From here, use accessToken to form all its requests
                TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken) // Get accessToken
                TwitterClient.sharedInstance.GET(                                           // Get credentials
                    "1.1/account/verify_credentials.json",
                    parameters: nil,
                    success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                        //                    print("user: \(response!)")
                        // User logging in
                        var user = User(dictionary: response as! NSDictionary)
                        // Once deserialized
                        User.currentUser = user
                        print("user: \(user.name)")
                        self.loginCompletion?(user: user, error: nil)
                    },  failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                        print("error getting current user")
                        self.loginCompletion?(user: nil, error: error)

                })
                
                
            }) { (error: NSError!) -> Void in
                print("Failed to receive access token")
                // Tell this, original caller that an error happened
                self.loginCompletion?(user: nil, error: error)
        }
    }
}