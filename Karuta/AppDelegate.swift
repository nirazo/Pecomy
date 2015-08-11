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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Fabric.with([Crashlytics()])
        self.setDefaultAppearance()
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        // 起動2回目以降
        if (NSUserDefaults.standardUserDefaults().boolForKey(Const.UD_KEY_HAS_LAUNCHED)) {
            let viewController = MainViewController()
            var navVC = UINavigationController(rootViewController: viewController)
            navVC.navigationBar.barTintColor = Const.KARUTA_THEME_COLOR
            self.window!.rootViewController = navVC
        } else {
            // 初回起動
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: Const.UD_KEY_HAS_LAUNCHED)
            NSUserDefaults.standardUserDefaults().synchronize()
            
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
        NSNotificationCenter.defaultCenter().postNotificationName("applicationWillEnterForeground", object: nil)
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func setDefaultAppearance(){
        // UINavigationBarのスタイルを設定
        //UINavigationBar.appearance().barTintColor = Const.KARUTA_THEME_COLOR
        UINavigationBar.appearance().tintColor = Const.KARUTA_THEME_TEXT_COLOR
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: Const.KARUTA_THEME_TEXT_COLOR]
    }


}

