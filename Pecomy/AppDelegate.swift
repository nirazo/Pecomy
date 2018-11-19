//
//  AppDelegate.swift
//  Pecomy
//
//  Created by Kenzo on 2015/06/21.
//  Copyright (c) 2015 Pecomy. All rights reserved.
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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self])
        GMSServices.provideAPIKey(cGoogleMapsAPIKey)
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        // GA
        // Configure tracker from GoogleService-Info.plist.
        var configureError:NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(String(describing: configureError))")
        
        // Optional: configure GAI options.
        let gai = GAI.sharedInstance()
        gai?.trackUncaughtExceptions = true  // report uncaught exceptions
        
        #if !RELEASE
            gai?.logger.logLevel = GAILogLevel.verbose  // remove before app release
        #endif
        
        let mainBaseVC = MainBaseViewController()
        let navVC = self.createTranslucentNavVC(mainBaseVC)
        self.window?.rootViewController = navVC
        self.window!.makeKeyAndVisible()
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {}
    
    func applicationDidEnterBackground(_ application: UIApplication) {}
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Const.WILL_ENTER_FOREGROUND_KEY), object: nil)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
        // ログインしてたら値復元
    }
    
    func applicationWillTerminate(_ application: UIApplication) {}
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    // navVCを透明化
    func createTranslucentNavVC(_ rootVC: UIViewController) -> UINavigationController {
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.navigationBar.tintColor = .clear
        navVC.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navVC.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Const.PECOMY_THEME_TEXT_COLOR]
        navVC.navigationBar.shadowImage = UIImage()
        return navVC
    }
}
