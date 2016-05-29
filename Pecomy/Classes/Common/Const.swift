//
//  Const.swift
//  Pecomy
//
//  Created by Kenzo on 2015/06/27.
//  Copyright (c) 2016 Pecomy. All rights reserved.
//

import Foundation

enum AnaylyticsTrackingCode: String {
    case MainViewController = "MainViewController"
    case RestaurantDetailViewController = "RestaurantDetailViewController"
    case ResultViewController = "ResultViewController"
}

struct Const {
    #if DEBUG
    static let API_BASE_PATH = "http://private-552a20-pecomyapi.apiary-mock.com"
    static let API_GOOD_BASE = "http://private-552a20-pecomyapi.apiary-mock.com/dummy_good"
    static let API_BLACKLIST_BASE = "http://private-552a20-pecomyapi.apiary-mock.com/dummy_blacklist"
    #elseif RELEASE
    static let API_BASE_PATH = "http://karuta.me/"
    static let API_GOOD_BASE = "http://karuta.me/dummy_good"
    static let API_BLACKLIST_BASE = "http://karuta.me/dummy_blacklist"
    #elseif STG
//    static let API_BASE_PATH = "http://karuta.me:10091/"
//    static let API_GOOD_BASE = "http://karuta.me:10091/dummy_good"
//    static let API_BLACKLIST_BASE = "http://karuta.me:10091/dummy_blacklist"
    static let API_BASE_PATH = "http://52.196.159.3:10090/"
    static let API_GOOD_BASE = "http://52.196.159.3:10090/dummy_good"
    static let API_BLACKLIST_BASE = "http://52.196.159.3:10090/dummy_blacklist"

    #endif
    
    #if FIXED_LOCATION
    static let FIXED_LATITUDE: Double = 35.661959
    static let FIXED_LONGITUDE: Double = 139.699789
    #else
    static let FIXED_LATITUDE: Double = 0.0
    static let FIXED_LONGITUDE: Double = 0.0
    #endif
    
    static let PECOMY_THEME_COLOR = UIColor(red: 78.0/255.0, green: 172.0/255.0, blue: 166.0/255.0, alpha: 1.0)
    static let PECOMY_THEME_TEXT_COLOR = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    
    static let RANKING_TOP_COLOR = UIColor(red: 255.0/255.0, green: 170.0/255.0, blue: 0/255.0, alpha: 1.0)
    static let RANKING_SECOND_COLOR = UIColor(red: 124.0/255.0, green: 132.0/255.0, blue: 139.0/255.0, alpha: 1.0)
    static let RANKING_SECOND_RIGHT_COLOR = UIColor(red: 102.0/255.0, green: 102/255.0, blue: 102.0/255.0, alpha: 1.0)
    static let BASIC_GRAY_COLOR = UIColor(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1.0)
    static let RIGHT_GRAY_COLOR = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
    
    static let PECOMY_TITLE = "Karuta"
    
    static let PECOMY_RANK_COLOR = [UIColor(red: 255/255.0, green: 180.0/255.0, blue: 0.0/255.0, alpha: 1.0),
        UIColor(red: 124.0/255.0, green: 132.0/255.0, blue: 139.0/255.0, alpha: 1.0),
        UIColor(red: 135.0/255.0, green: 110.0/255.0, blue: 63.0/255.0, alpha: 1.0)]
    
    static let PECOMY_RESULT_BACK_COLOR = UIColor(red: 238.0/255.0, green: 236.0/255.0, blue: 233.0/255.0, alpha: 1.0)
    static let PECOMY_CARD_IMAGE_BACK_COLOR = UIColor(red: 231.0/255.0, green: 232.0/255.0, blue: 233.0/255.0, alpha: 1.0)
    
    static let PECOMY_BASIC_BACKGROUND_COLOR = UIColor(red: 235.0/255.0, green: 231.0/255.0, blue: 225.0/255.0, alpha: 1.0)
    static let PECOMY_RIGHT_BACKGROUND_COLOR = UIColor(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1.0)
    
    // フォント
    static let PECOMY_FONT_NORMAL = ".HiraKakuInterface-W3"
    static let PECOMY_FONT_BOLD = ".HiraKakuInterface-W6"
    
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
    
    // 角丸の半径
    static let CORNER_RADIUS: CGFloat = 5.0
    
    // NotificationCenterのキー
    static let WILL_ENTER_FOREGROUND_KEY = "applicationWillEnterForeground"
    
    // GoogleMaps SDKのAPIキー
    static let GOOGLEMAP_API_KEY = "AIzaSyDoWEe-eYp1z0SaJ64JkQ2TuDzK1YOatmw"
    
    // ウインドウのサイズ
    static let WindowSize = UIScreen.mainScreen().bounds.size
    
    // Keychain
    static let UserTokenKeychainKey = "PecomyUserToken"
}
