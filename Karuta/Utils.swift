//
//  Utils.swift
//  Karuta
//
//  Created by Kenzo on 2015/08/30.
//  Copyright (c) 2015年 Karuta. All rights reserved.
//

import Foundation
import CoreLocation

// 中身が増えてきたらUtilは分けていこうかと
class Utils {
    class func acquireDeviceID() -> String {
        return UIDevice.currentDevice().identifierForVendor!.UUIDString
    }
    
    class func distanceBetweenLocations(fromLat: Double, fromLon: Double, toLat: Double, toLon: Double) -> CLLocationDistance {
        let from = CLLocation(latitude: fromLat, longitude: fromLon)
        let to = CLLocation(latitude: toLat, longitude: toLon)
        return to.distanceFromLocation(from)
    }
    
    /**
    カードに表示する価格を整形する
    頭に￥をつけ、三桁区切りカンマをつける
    */
    class func formatPriceString(origPrice: String) -> String {
        let price = Int(origPrice)
        guard let intPrice = price else {
            return ""
        }
        let num = NSNumber(integer: intPrice)
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        
        return "￥\(formatter.stringFromNumber(num)!)"
    }
}
