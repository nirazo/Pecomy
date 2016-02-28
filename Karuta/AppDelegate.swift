//
//  AppDelegate.swift
//  Karuta
//
//  Created by Kenzo on 2015/06/21.
//  Copyright (c) 2015年 Karuta. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let cGoogleMapsAPIKey = Const.GOOGLEMAP_API_KEY

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Fabric.with([Crashlytics()])
        GMSServices.provideAPIKey(cGoogleMapsAPIKey)
        
        self.setupAppearance()
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        // Configure tracker from GoogleService-Info.plist.
        var configureError:NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        // Optional: configure GAI options.
        let gai = GAI.sharedInstance()
        gai.trackUncaughtExceptions = true  // report uncaught exceptions
        
        #if !RELEASE
        gai.logger.logLevel = GAILogLevel.Verbose  // remove before app release
        #endif
        
        // 起動2回目以降
        if (NSUserDefaults.standardUserDefaults().boolForKey(Const.UD_KEY_HAS_LAUNCHED)) {
            let viewController = MainBaseViewController()
            //let navVC = UINavigationController(rootViewController: viewController)
            self.window?.rootViewController = viewController
        } else {
            // 初回起動
            let viewController = TutorialViewController()
            self.window?.rootViewController = viewController
        }
        self.window!.makeKeyAndVisible()
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
        NSNotificationCenter.defaultCenter().postNotificationName(Const.WILL_ENTER_FOREGROUND_KEY, object: nil)
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func setupAppearance(){
        // UINavigationBarのスタイルを設定
        //UINavigationBar.appearance().barTintColor = Const.KARUTA_THEME_COLOR
        //UINavigationBar.appearance().tintColor = Const.KARUTA_THEME_TEXT_COLOR
        //UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: Const.KARUTA_THEME_TEXT_COLOR]
    }


}

