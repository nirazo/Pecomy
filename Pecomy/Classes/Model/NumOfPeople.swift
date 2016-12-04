//
//  NumOfPeople.swift
//  Pecomy
//
//  Created by Kenzo on 2016/02/02.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import UIKit

enum NumOfPeople: Int {
    case one, two, moreThanThree, _counter
    
    func valueForDisplay() -> String {
        switch self {
        case .one:
            return NSLocalizedString("OnePerson", comment: "")
        case .two:
            return NSLocalizedString("TwoPeople", comment: "")
        case .moreThanThree:
            return NSLocalizedString("OverThreePeople", comment: "")
        default:
            return ""
        }
    }
}
