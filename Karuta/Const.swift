//
//  Const.swift
//  Karuta
//
//  Created by Kenzo on 2015/06/27.
//  Copyright (c) 2015年 Karuta. All rights reserved.
//

import Foundation

enum AnaylyticsTrackingCode: String {
    case MainViewController = "MainViewController"
    case RestaurantDetailViewController = "RestaurantDetailViewController"
    case ResultViewController = "ResultViewController"
}

struct Const {
    #if DEBUG
    static let API_BASE_PATH = "http://private-552a20-karutaapi.apiary-mock.com/"
    static let API_CARD_BASE = "http://private-552a20-karutaapi.apiary-mock.com/card"
    static let API_RESULT_BASE = "http://private-552a20-karutaapi.apiary-mock.com/results"
    static let API_GOOD_BASE = "http://private-552a20-karutaapi.apiary-mock.com/dummy_good"
    static let API_BLACKLIST_BASE = "http://private-552a20-karutaapi.apiary-mock.com/dummy_blacklist"
    #elseif RELEASE
    static let API_BASE_PATH = "http://karuta.me/"
    static let API_CARD_BASE = "http://karuta.me/card"
    static let API_RESULT_BASE = "http://karuta.me/results"
    static let API_GOOD_BASE = "http://karuta.me/dummy_good"
    static let API_BLACKLIST_BASE = "http://karuta.me/dummy_blacklist"
    #else
    static let API_BASE_PATH = "http://karuta.me/"
    static let API_CARD_BASE = "http://karuta.me/card"
    static let API_RESULT_BASE = "http://karuta.me/results"
    static let API_GOOD_BASE = "http://karuta.me/dummy_good"
    static let API_BLACKLIST_BASE = "http://karuta.me/dummy_blacklist"
    #endif
    
    #if FIXED_LOCATION
    static let FIXED_LATITUDE: Double = 35.661959
    static let FIXED_LONGITUDE: Double = 139.699789
    #else
    static let FIXED_LATITUDE: Double = 0.0
    static let FIXED_LONGITUDE: Double = 0.0
    #endif
    
    static let KARUTA_THEME_COLOR = UIColor(red: 207.0/255.0, green: 83.0/255.0, blue: 41.0/255.0, alpha: 1.0)
    static let KARUTA_THEME_TEXT_COLOR = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    
    static let RANKING_TOP_COLOR = UIColor(red: 255.0/255.0, green: 170.0/255.0, blue: 0/255.0, alpha: 1.0)
    static let RANKING_SECOND_COLOR = UIColor(red: 124.0/255.0, green: 132.0/255.0, blue: 139.0/255.0, alpha: 1.0)
    static let RANKING_SECOND_RIGHT_COLOR = UIColor(red: 102.0/255.0, green: 102/255.0, blue: 102.0/255.0, alpha: 1.0)
    
    static let KARUTA_TITLE = "Karuta"
    
    static let KARUTA_RANK_COLOR = [UIColor(red: 255/255.0, green: 180.0/255.0, blue: 0.0/255.0, alpha: 1.0),
        UIColor(red: 124.0/255.0, green: 132.0/255.0, blue: 139.0/255.0, alpha: 1.0),
        UIColor(red: 135.0/255.0, green: 110.0/255.0, blue: 63.0/255.0, alpha: 1.0)]
    
    static let KARUTA_RESULT_BACK_COLOR = UIColor(red: 238.0/255.0, green: 236.0/255.0, blue: 233.0/255.0, alpha: 1.0)
    static let KARUTA_CARD_IMAGE_BACK_COLOR = UIColor(red: 231.0/255.0, green: 232.0/255.0, blue: 233.0/255.0, alpha: 1.0)
    
    // フォント
    static let KARUTA_FONT_NORMAL = "HiraKakuProN-W3"
    static let KARUTA_FONT_BOLD = "HiraKakuProN-W6"
    
    // userdefaultsのキー
    static let UD_KEY_HAS_LAUNCHED = "HasLaunchedOnce"
    
    // 距離関連
    static let RETRY_DISTANCE : Double = 500.0
    
    // ネットワーク周り
    static let ALAMOFIRE_TIMEOUT_SEC: Double = 12.0
    static let STATUS_CODE_SUCCESS = 200
    static let STATUS_CODE_SERVER_ERROR = 500
    static let STATUS_CODE_NOT_FOUND = 404
    static let STATUS_CODE_BAD_REQUEST = 400
    
    // カード上のテキスト
    static let CARD_LIKE_COLOR = UIColor.whiteColor()
    static let CARD_DISLIKE_COLOR = UIColor.whiteColor()
    
    // NotificationCenterのキー
    static let WILL_ENTER_FOREGROUND_KEY = "applicationWillEnterForeground"
    
    // GoogleMaps SDKのAPIキー
    static let GOOGLEMAP_API_KEY = "AIzaSyDoWEe-eYp1z0SaJ64JkQ2TuDzK1YOatmw"
}
