//
//  User.swift
//  Twitter
//
//  Created by Che Chao Hsu on 2/9/16.
//  Copyright © 2016 Che Chao Hsu. All rights reserved.
//

import UIKit

var _currentUser: User? // Hack because we do not have class or type var's
let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    var dictionary: NSDictionary
    var name: String?
    var screenname: String?
    var profileImageURL: NSURL?
    var tagline: String?
    var favourited: Bool?
    var favouritesCount: Int?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        // de-serialize dictionary into above var's
        name = dictionary["name"] as? String
        screenname = dictionary["screenname"] as? String
        let profileImageURLString = dictionary["profile_image_url"] as? String
        if profileImageURLString != nil {
            profileImageURL = NSURL(string: profileImageURLString!)!
        } else {
            profileImageURL = nil
        }
        tagline = dictionary["description"] as? String
        favourited = dictionary["favourited"] as? Bool
        favouritesCount = dictionary["favourites_count"] as? Int
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        // Lots of view controllers interested in global events; tell any interested logout happened
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    // Global notion of currentUser anytime
    class var currentUser: User? {
        get {
            // No currentUser or just booted
            if _currentUser == nil {
                // At least check NSUserDefaults
                let responseData = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                if responseData != nil {
                    // let responseDictionary: NSDictionary?
                    do {
                        let responseDictionary = try NSJSONSerialization.JSONObjectWithData(responseData!, options: .MutableContainers) as? NSDictionary
                        _currentUser = User(dictionary: responseDictionary!)
                    } catch {
                        print(error)
                    }
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            if _currentUser != nil {
                var responseData: NSData?
                do {
                    // Change it to serialized JSON string
                    try responseData = NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: .PrettyPrinted)
                    NSUserDefaults.standardUserDefaults().setObject(responseData, forKey: currentUserKey)
                } catch {
                    print(error)
                }
            } else {
                // Clear currentUser
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
}