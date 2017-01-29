//
//  Budget.swift
//  Pecomy
//
//  Created by Kenzo on 2016/02/02.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import UIKit

enum Budget: Int {
    case unspecified, lessThanThousand, lessThanTwoThousand, _counter
    
    func valueForDisplay() -> String {
        switch self {
        case .unspecified:
            return NSLocalizedString("Unspecified", comment: "")
        case .lessThanThousand:
            return NSLocalizedString("LessThanThousand", comment: "")
        case .lessThanTwoThousand:
            return NSLocalizedString("LessThanTwoThousand", comment: "")
        default:
            return ""
        }
    }
}
