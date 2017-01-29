//
//  PecomyResult.swift
//  Pecomy
//
//  Created by Kenzo on 2015/12/29.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import Foundation

public enum PecomyResult<Value, Error> {

    case success(Value)
    case failure(Error)
    
    public init(value: Value) {
        self = .success(value)
    }
    
    public init(error: Error) {
        self = .failure(error)
    }
}
