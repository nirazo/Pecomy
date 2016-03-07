//
//  BackgroundImagePicker.swift
//  Karuta
//
//  Created by Kenzo on 2016/03/01.
//  Copyright © 2016年 Karuta. All rights reserved.
//

import Foundation

class BackgroundImagePicker {
    /**
     時刻によって異なる背景画像を返す
     
     6時台 < 現在時刻 < 18時台の場合は昼の画像
     
     それ以外は昼の画像
     */
    class func pickImage() -> UIImage {
        let currentDate = NSDate()
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let hour = calendar.components(NSCalendarUnit.Hour, fromDate: currentDate).hour
        let n = arc4random() % 3 + 1
        if (6 < hour && hour < 18) {
            return UIImage(named: "background_afternoon\(n)")!
            
        } else {
            return UIImage(named: "background_night\(n)")!
        }
    }
}
