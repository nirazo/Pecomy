//
//  Category.swift
//  Pecomy
//
//  Created by Kenzo on 2015/10/21.
//  Copyright © 2016年 Pecomy. All rights reserved.
//

import Foundation

enum Genre: Int {
    case All, Cafe, Drinking, Restaurant, _counter//Ramen
    
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
//        case .Ramen:
//            return NSLocalizedString("CategoryRamen", comment: "")
        default:
            return ""
        }
    }
}