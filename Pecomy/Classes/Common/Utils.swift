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
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
    class func distanceBetweenLocations(_ fromLat: Double, fromLon: Double, toLat: Double, toLon: Double) -> CLLocationDistance {
        let from = CLLocation(latitude: fromLat, longitude: fromLon)
        let to = CLLocation(latitude: toLat, longitude: toLon)
        return to.distance(from: from)
    }
    
    /**
    頭に￥をつけ、三桁区切りカンマをつける
     - parameter origPrice: 元の値段文字列
     - returns: 頭に￥が付いた、3桁区切りカンマがついた値段文字列
    */
    class func formatPriceString(_ origPrice: String) -> String {
        let price = Int(origPrice)
        guard let intPrice = price else {
            return ""
        }
        let num = NSNumber(value: intPrice)
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        
        return "￥\(formatter.string(from: num)!)"
    }
    
    /**
     距離（メートル）を分に変換
     - parameter meter: 距離（メートル）
     - returns: 分
     */
    class func meterToMinutes(_ meter: Double) -> Int{
        return Int(ceil(meter/60))
    }
    
    /**
     yyyy-MM-dd HH:mm:ssを日付のみの文字列に変換
     - parameter dateStr: 日付文字列
     - returns: 日付
     */
    class func dateStringToShort(_ dateStr: String) -> String {
        let replacedStr = dateStr.replacingOccurrences(of: "-", with: "/")
        let separetedArray = replacedStr.components(separatedBy: " ")
        return separetedArray[0]
    }
    
    /**
     yyyy-MM-dd HH:mm:ssを時刻のみの文字列に変換
     - parameter dateStr: 日付文字列
     - returns: 時刻
     */
    class func dateStringToTimeString(_ dateStr: String) -> String {
        let replacedStr = dateStr.replacingOccurrences(of: "-", with: "/")
        let separetedArray = replacedStr.components(separatedBy: " ")
        return separetedArray[1]
    }
}
