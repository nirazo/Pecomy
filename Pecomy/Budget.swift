//
//  Budget.swift
//  Pecomy
//
//  Created by Kenzo on 2016/02/02.
//  Copyright © 2016年 Pecomy. All rights reserved.
//

import UIKit

enum Budget: Int {
    case Unspecified, LessThanThousand, LessThanTwoThousand, _counter
    
    func valueForDisplay() -> String {
        switch self {
        case .Unspecified:
            return NSLocalizedString("Unspecified", comment: "")
        case .LessThanThousand:
            return NSLocalizedString("LessThanThousand", comment: "")
        case .LessThanTwoThousand:
            return NSLocalizedString("LessThanTwoThousand", comment: "")
        default:
            return ""
        }
    }
}
