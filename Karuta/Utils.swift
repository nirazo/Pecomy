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
        return UIDevice.currentDevice().identifierForVendor.UUIDString
    }
    
    class func distanceBetweenLocations(fromLat: Double, fromLon: Double, toLat: Double, toLon: Double) -> CLLocationDistance {
        let from = CLLocation(latitude: fromLat, longitude: fromLon)
        let to = CLLocation(latitude: toLat, longitude: toLon)
        return to.distanceFromLocation(from)
    }
    
    /**
    カードに表示する価格を整形する
    食べログの価格は
    [夜]1000~2000          [昼]1000~2000
    みたいな形なので、コレを整形してカードに表記する形にする。
    */
    class func formatPriceString(origPrice: String) -> String {
        var replacedString = origPrice.stringByReplacingOccurrencesOfString("  +", withString: "\n", options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
        var formattedPrice = ""
        let prices = replacedString.componentsSeparatedByString("\n")
        if (prices.count < 2) {
            if (prices[0].isEmpty) {
                formattedPrice = NSLocalizedString("CardNoPriceInfoText", comment: "")
            } else {
                formattedPrice = prices[0]
            }
        } else {
            formattedPrice = prices[1] + "\n" + prices[0]
        }
        return formattedPrice
    }
}
