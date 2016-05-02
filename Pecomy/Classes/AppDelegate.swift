//
//  AppDelegate.swift
//  Pecomy
//
//  Created by Kenzo on 2015/06/21.
//  Copyright (c) 2015年 Pecomy. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import GoogleMaps
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let cGoogleMapsAPIKey = Const.GOOGLEMAP_API_KEY
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Fabric.with([Crashlytics()])
        GMSServices.provideAPIKey(cGoogleMapsAPIKey)
        
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
            FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        #endif
        
        let mainBaseVC = MainBaseViewController()
        let navVC = self.createTransrateNavVC(mainBaseVC)
        self.window?.rootViewController = navVC
        self.window!.makeKeyAndVisible()
        
        //FBSDKSettings.setAppID("1675450129386792")
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

        
        //return true
    }
    
    func applicationWillResignActive(application: UIApplication) {}
    
    func applicationDidEnterBackground(application: UIApplication) {}
    
    func applicationWillEnterForeground(application: UIApplication) {
        NSNotificationCenter.defaultCenter().postNotificationName(Const.WILL_ENTER_FOREGROUND_KEY, object: nil)
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
    
    func applicationWillTerminate(application: UIApplication) {}
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    // navVCを透明化
    func createTransrateNavVC(rootVC: UIViewController) -> UINavigationController {
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.navigationBar.tintColor = UIColor.clearColor()
        navVC.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navVC.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Const.PECOMY_THEME_TEXT_COLOR]
        navVC.navigationBar.shadowImage = UIImage()
        return navVC
    }
}
