//
//  Const.swift
//  Karuta
//
//  Created by Kenzo on 2015/06/27.
//  Copyright (c) 2015年 Karuta. All rights reserved.
//

import Foundation

struct Const {
    static let DEVICE_ID = UIDevice.currentDevice().identifierForVendor.UUIDString
    static let API_CARD_BASE = "http://radioplant.bookside.net/card"
    static let API_RESULT_BASE = "http://radioplant.bookside.net/results"
    //static let API_CARD_BASE = "http://private-552a20-ffaapi.apiary-mock.com/card"
    //static let API_RESULT_BASE = "http://private-552a20-ffaapi.apiary-mock.com/results"
    
    static let KARUTA_THEME_COLOR = UIColor(red: 207.0/255.0, green: 83.0/255.0, blue: 41.0/255.0, alpha: 1.0)
    static let KARUTA_THEME_TEXT_COLOR = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    
    static let KARUTA_TITLE = "Karuta"
    
    static let ROW_HEIGHT_RESULTVIEW: CGFloat = 150.0;    
}
