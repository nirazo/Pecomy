//
//  Utils.swift
//  Pecomy
//
//  Created by Kenzo on 2015/08/30.
//  Copyright (c) 2016 Pecomy. All rights reserved.
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
    頭に￥をつけ、三桁区切りカンマをつける
     - parameter origPrice: 元の値段文字列
     - returns: 頭に￥が付いた、3桁区切りカンマがついた値段文字列
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
    
    /**
     距離（メートル）を分に変換
     - parameter meter: 距離（メートル）
     - returns: 分
     */
    class func meterToMinutes(meter: Double) -> Int{
        return Int(ceil(meter/60))
    }
}
