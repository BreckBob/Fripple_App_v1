//
//  AppDelegate.swift
//  Fripple_App_v1
//
//  Created by Bob McGinn on 10/31/15.
//  Copyright © 2015 REM Designs. All rights reserved.
//

import UIKit
import Parse
import Bolts
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit
import ParseFacebookUtilsV4

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
        //Code to handle making Splash view the initial one
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewControllerWithIdentifier("SplashViewController")
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
        //Parse code to enable local datastore. Not being used currently
        Parse.enableLocalDatastore()
        
        // Initialize Parse.
        Parse.setApplicationId("DtEhd5MxsYdelQL14IkuBXkhEKvSI6SU92crIrYA",
            clientKey: "afyAkHukBJV7UF1NTJcD4hPk4wqo9EvUMMqU8u2G")
        
        //Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        //Code to incorporate Facebook. Not right now cause cannot bring in phone number
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        
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
        
        //Code to incorporate Facebook. Not right now cause cannot bring in phone number
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //Code to incorporate Facebook. Not right now cause cannot bring in phone number
    func application(application: UIApplication,
        openURL url: NSURL,
        sourceApplication: String?,
        annotation: AnyObject) -> Bool {
            return FBSDKApplicationDelegate.sharedInstance().application(application,
                openURL: url,
                sourceApplication: sourceApplication,
                annotation: annotation)
    }


}

