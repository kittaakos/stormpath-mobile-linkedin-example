//
//  AppDelegate.swift
//  Stormpath iOS Example
//
//  Created by Edward Jiang on 2/18/16.
//  Copyright © 2016 Stormpath. All rights reserved.
//

import UIKit
import Stormpath

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        return true
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

    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        linkedinCallback(url)
        return Stormpath.sharedSession.application(app, openURL: url, options: options)
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        linkedinCallback(url)
        return Stormpath.sharedSession.application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func linkedinCallback(url: NSURL) {
        if url.scheme == "testapp12345" && url.host == "authorize" && url.path == "/linkedin" {
            if let accessToken = url.queryDictionary["access_token"] {
                let loginViewController = window?.rootViewController as? LoginViewController
                Stormpath.sharedSession.login(socialProvider: .LinkedIn, accessToken: accessToken, completionHandler: loginViewController?.loginCompletionHandler)
            }
        }
    }

}

extension NSURL {
    /// Dictionary with key/value pairs from the URL query string
    var queryDictionary: [String: String] {
        return dictionaryFromFormEncodedString(query)
    }
    
    private func dictionaryFromFormEncodedString(input: String?) -> [String: String] {
        var result = [String: String]()
        
        guard let input = input else {
            return result
        }
        let inputPairs = input.componentsSeparatedByString("&")
        
        for pair in inputPairs {
            let split = pair.componentsSeparatedByString("=")
            if split.count == 2 {
                if let key = split[0].stringByRemovingPercentEncoding, value = split[1].stringByRemovingPercentEncoding {
                    result[key] = value
                }
            }
        }
        return result
    }
}