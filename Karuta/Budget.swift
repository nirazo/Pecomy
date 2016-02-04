//
//  Budget.swift
//  Karuta
//
//  Created by Kenzo on 2016/02/02.
//  Copyright © 2016年 Karuta. All rights reserved.
//

import UIKit

enum Budget: Int {
    case LessThanThousand, LessThanTwoThousand, Nothing, _counter
    
    func valueForDisplay() -> String {
        switch self {
        case .LessThanThousand:
            return NSLocalizedString("LessThanThousand", comment: "")
        case .LessThanTwoThousand:
            return NSLocalizedString("LessThanTwoThousand", comment: "")
        case .Nothing:
            return NSLocalizedString("CategoryDrinking", comment: "")
        default:
            return ""
        }
    }
    
    func valueForReq() -> String {
        switch self {
        case .LessThanThousand:
            return "1000"
        case .LessThanTwoThousand:
            return "2000"
        case .Nothing:
            return ""
        default:
            return ""
        }
    }
}
