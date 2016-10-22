//
//  UINavigationController.swift
//  Pecomy
//
//  Created by Kenzo on 7/3/16.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import Foundation

extension UINavigationController {
    func makeNavigationBarTranslucent() {
        self.navigationBar.tintColor = .clearColor()
        self.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Const.PECOMY_THEME_TEXT_COLOR]
        self.navigationBar.shadowImage = UIImage()
    }
    
    func makeNavigationBarDefault(){
        self.navigationBar.tintColor = Const.PECOMY_THEME_COLOR
        self.navigationBar.barTintColor = Const.PECOMY_RIGHT_BACKGROUND_COLOR
        self.navigationBar.setBackgroundImage(nil, forBarMetrics: .Default)
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Const.PECOMY_THEME_COLOR]
    }
}