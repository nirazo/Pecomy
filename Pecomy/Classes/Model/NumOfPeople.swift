//
//  NumOfPeople.swift
//  Pecomy
//
//  Created by Kenzo on 2016/02/02.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import UIKit

enum NumOfPeople: Int {
    case One, Two, MoreThanThree, _counter
    
    func valueForDisplay() -> String {
        switch self {
        case .One:
            return NSLocalizedString("OnePerson", comment: "")
        case .Two:
            return NSLocalizedString("TwoPeople", comment: "")
        case .MoreThanThree:
            return NSLocalizedString("OverThreePeople", comment: "")
        default:
            return ""
        }
    }
}
