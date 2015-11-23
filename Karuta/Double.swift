//
//  Double.swift
//  Karuta
//
//  Created by Kenzo on 2015/11/23.
//  Copyright © 2015年 Karuta. All rights reserved.
//

import Foundation

extension Double {
    func meterToMinutes() -> Int{
        return Int(ceil(self/80))
    }
}
