//
//  NumOfPeople.swift
//  Karuta
//
//  Created by Kenzo on 2016/02/02.
//  Copyright © 2016年 Karuta. All rights reserved.
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
    
    func valueForReq() -> String {
        switch self {
        case .One:
            return "1"
        case .Two:
            return "2"
        case .MoreThanThree:
            return ""
        default:
            return ""
        }
    }

}
