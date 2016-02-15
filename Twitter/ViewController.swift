//
//  ViewController.swift
//  Twitter https://apps.twitter.com/app/9509457
//
//  Created by Che Chao Hsu on 2/8/16.
//  Copyright © 2016 Che Chao Hsu. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogin(sender: AnyObject) {
        // Pass in closure: user or error
        TwitterClient.sharedInstance.loginWithCompletion() {
            (user: User?, error: NSError?) in   // ? if exist
            if user != nil {
                self.performSegueWithIdentifier("loginSegue", sender: self)
            } else {
                // handle login error
            }
        }
    }
}