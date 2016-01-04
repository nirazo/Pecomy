//
//  KarutaResult.swift
//  Karuta
//
//  Created by Kenzo on 2015/12/29.
//  Copyright © 2015年 Karuta. All rights reserved.
//

import Foundation

public enum KarutaResult<Value, Error> {

    case Success(Value)
    case Failure(Error)
    
    public init(value: Value) {
        self = .Success(value)
    }
    
    public init(error: Error) {
        self = .Failure(error)
    }
}
