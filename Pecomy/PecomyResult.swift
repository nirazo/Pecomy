//
//  PecomyResult.swift
//  Pecomy
//
//  Created by Kenzo on 2015/12/29.
//  Copyright © 2016年 Pecomy. All rights reserved.
//

import Foundation

public enum PecomyResult<Value, Error> {

    case Success(Value)
    case Failure(Error)
    
    public init(value: Value) {
        self = .Success(value)
    }
    
    public init(error: Error) {
        self = .Failure(error)
    }
}
