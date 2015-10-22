//
//  Category.swift
//  Karuta
//
//  Created by Kenzo on 2015/10/21.
//  Copyright © 2015年 Karuta. All rights reserved.
//

import Foundation

enum CategoryIdentifier: Int {
    case All
    case Cafe
    case Drinking
    case Restaurant
    
    case _counter // カウンタ
    
    func valueForDisplay() -> String {
        switch self {
        case .All:
            return NSLocalizedString("CategoryAll", comment: "")
        case .Cafe:
            return NSLocalizedString("CategoryCafe", comment: "")
        case .Drinking:
            return NSLocalizedString("CategoryDrinking", comment: "")
        case .Restaurant:
            return NSLocalizedString("CategoryRestaurant", comment: "")
        default:
            return ""
        }
    }
    
    func valueForReq() -> String {
        switch self {
        case .All:
            return "all"
        case .Cafe:
            return "cafe"
        case .Drinking:
            return "drinking"
        case .Restaurant:
            return "restaurant"
        default:
            return ""
        }
    }
}
