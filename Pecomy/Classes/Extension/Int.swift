//
//  Int.swift
//  Pecomy
//
//  Created by Kenzo on 2015/12/29.
//  Copyright © 2016年 Pecomy. All rights reserved.
//

import Foundation

extension Int {
    func toThreeDigitComma() -> String{
        let num = NSNumber(integer: self)
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        let result = formatter.stringFromNumber(num) ?? ""
        return result
    }
}
