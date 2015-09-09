//
//  Utils.swift
//  Karuta
//
//  Created by Kenzo on 2015/08/30.
//  Copyright (c) 2015年 Karuta. All rights reserved.
//

import Foundation
import CoreLocation

class Utils {
    class func acquireDeviceID() -> String {
        return UIDevice.currentDevice().identifierForVendor.UUIDString
    }
    
    class func distanceBetweenLocations(from: CLLocation, to: CLLocation) -> CLLocationDistance {
        return to.distanceFromLocation(from)
    }
}
