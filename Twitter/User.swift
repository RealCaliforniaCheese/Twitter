//
//  User.swift
//  Twitter
//
//  Created by Che Chao Hsu on 2/9/16.
//  Copyright © 2016 Che Chao Hsu. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String?
    var screenname: String?
    var profileImageURL: String?
    var tagline: String?
    var dictionary: NSDictionary
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        // de-serialize dictionary into above var's
        name = dictionary["name"] as? String
        screenname = dictionary["screenname"] as? String
        profileImageURL = dictionary["profile_image_url"] as? String
        tagline = dictionary["description"] as? String
    }
}
