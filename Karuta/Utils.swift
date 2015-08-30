//
//  Utils.swift
//  Karuta
//
//  Created by Kenzo on 2015/08/30.
//  Copyright (c) 2015年 Karuta. All rights reserved.
//

import Foundation

class Utils {
    class func acquireDeviceID() -> String {
        return UIDevice.currentDevice().identifierForVendor.UUIDString
    }
}
