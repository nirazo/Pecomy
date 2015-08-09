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
    
    #if DEBUG
        static let API_CARD_BASE = "http://private-552a20-ffaapi.apiary-mock.com/card"
        static let API_RESULT_BASE = "http://private-552a20-ffaapi.apiary-mock.com/results"
    #elseif RELEASE
        static let API_CARD_BASE = "http://52.68.156.26:10090/card"
        static let API_RESULT_BASE = "http://52.68.156.26:10090/results"
    #else
        static let API_CARD_BASE = "http://52.68.156.26:10090/card"
        static let API_RESULT_BASE = "http://52.68.156.26:10090/results"
    #endif
    
    #if FIXED_LOCATION
        static let FIXED_LATITUDE: Double = 35.607762
        static let FIXED_LONGITUDE: Double = 139.734562
    #else
        static let FIXED_LATITUDE: Double = 0.0
        static let FIXED_LONGITUDE: Double = 0.0
    #endif
    
    static let KARUTA_THEME_COLOR = UIColor(red: 207.0/255.0, green: 83.0/255.0, blue: 41.0/255.0, alpha: 1.0)
    static let KARUTA_THEME_TEXT_COLOR = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    
    static let RANKING_TOP_COLOR = UIColor(red: 255.0/255.0, green: 180.0/255.0, blue: 0/255.0, alpha: 1.0)
    static let RANKING_SECOND_COLOR = UIColor(red: 124.0/255.0, green: 132.0/255.0, blue: 139.0/255.0, alpha: 1.0)
    static let RANKING_THIRD_COLOR = UIColor(red: 135.0/255.0, green: 110.0/255.0, blue: 63.0/255.0, alpha: 1.0)
    
    static let KARUTA_TITLE = "Karuta"
    
    static let KARUTA_RANK_COLOR = [UIColor(red: 255/255.0, green: 180.0/255.0, blue: 0.0/255.0, alpha: 1.0),
        UIColor(red: 124.0/255.0, green: 132.0/255.0, blue: 139.0/255.0, alpha: 1.0),
        UIColor(red: 135.0/255.0, green: 110.0/255.0, blue: 63.0/255.0, alpha: 1.0)]
}
