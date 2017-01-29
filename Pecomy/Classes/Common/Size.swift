//
//  Size.swift
//  Pecomy
//
//  Created by Kenzo on 6/5/16.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import UIKit

struct Size {
    
    static func statusBarHeight() -> CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
    
    static func navBarHeight(_ navigationController: UINavigationController) -> CGFloat {
        return navigationController.navigationBar.frame.size.height
    }
    
    static func navHeightIncludeStatusBar(_ navigationController: UINavigationController) -> CGFloat {
        return statusBarHeight() + navBarHeight(navigationController)
    }
}
