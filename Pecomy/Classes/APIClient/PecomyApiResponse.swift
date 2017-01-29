//
//  PecomyApiResponse.swift
//  Pecomy
//
//  Created by Kenzo on 2015/12/29.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import Foundation
import ObjectMapper

open class PecomyApiResponse: Mappable {
    
    var code = 0
    var message = ""
    
    public init() {}
    
    public required init?(map: Map) {
        mapping(map: map)
    }
    
    open func mapping(map: Map) {
        code <- map["body.code"]
        message <- map["message"]
    }
}
