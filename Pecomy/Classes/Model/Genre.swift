//
//  Category.swift
//  Pecomy
//
//  Created by Kenzo on 2015/10/21.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import Foundation

enum Genre: Int {
    case all, cafe, drinking, restaurant, _counter//Ramen
    
    func valueForDisplay() -> String {
        switch self {
        case .all:
            return NSLocalizedString("CategoryAll", comment: "")
        case .cafe:
            return NSLocalizedString("CategoryCafe", comment: "")
        case .drinking:
            return NSLocalizedString("CategoryDrinking", comment: "")
        case .restaurant:
            return NSLocalizedString("CategoryRestaurant", comment: "")
//        case .Ramen:
//            return NSLocalizedString("CategoryRamen", comment: "")
        default:
            return ""
        }
    }
}
