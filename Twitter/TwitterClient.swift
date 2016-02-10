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
}