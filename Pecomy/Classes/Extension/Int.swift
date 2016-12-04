//
//  Int.swift
//  Pecomy
//
//  Created by Kenzo on 2015/12/29.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import Foundation

extension Int {
    func toThreeDigitComma() -> String{
        let num = NSNumber(value: self as Int)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        let result = formatter.string(from: num) ?? ""
        return result
    }
}
