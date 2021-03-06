//
//  AppDelegate.swift
//  Twitter
//
//  Created by Che Chao Hsu on 2/8/16.
//  Copyright © 2016 Che Chao Hsu. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var storyboard = UIStoryboard(name: "Main", bundle: nil)

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userDidLogout", name: userDidLogoutNotification, object: nil)
        
        if User.currentUser != nil {
            // Go to the logged-in/timeline screen
            print("Current user detected: \(User.currentUser?.name)")
            let vc =
            storyboard.instantiateViewControllerWithIdentifier("TweetsViewController") as UIViewController
            window?.rootViewController = vc // = arrow in storyboard
            

        }
        
        // Set up the tab and navigation bar controllers
//        var currController = window?.rootViewController
//        
//        let chatSB = UIStoryboard(name: "Chat", bundle: nil)
//        let mainSB = UIStoryboard(name: "Main", bundle: nil)
//        
//        let tabBarController     = UITabBarController()
//        var navigationController = UINavigationController(rootViewController: currController!)
//        
//        let profileNavController = mainSB.instantiateViewControllerWithIdentifier("profileNavController")   as UINavigationController
//        let chatNavController    = chatSB.instantiateViewControllerWithIdentifier("chatInboxNavController") as UINavigationController
//        
//        tabBarController.viewControllers = [profileNavController, chatNavController, navigationController]
//        window?.rootViewController = tabBarController
        
        return true
    }
    
    func userDidLogout() {
        let vc = storyboard.instantiateInitialViewController()! as UIViewController
        window?.rootViewController = vc
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        // Called when redirect via URL (for now Twitter, in future check request is oauth)
        TwitterClient.sharedInstance.openURL(url)
        
        return true
    }
}

