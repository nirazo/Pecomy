//
//  PecomyApiResponse.swift
//  Pecomy
//
//  Created by Kenzo on 2015/12/29.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import Foundation
import ObjectMapper

public class PecomyApiResponse: Mappable {
    
    var code = 0
    var message = ""
    
    public init() {}
    
    public required init?(_ map: Map) {
        mapping(map)
    }
    
    public func mapping(map: Map) {
        code <- map["body.code"]
        message <- map["message"]
    }
}
