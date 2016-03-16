//
//  KarutaApiResponse.swift
//  Karuta
//
//  Created by Kenzo on 2015/12/29.
//  Copyright © 2015年 Karuta. All rights reserved.
//

import Foundation
import ObjectMapper

public class KarutaApiResponse: Mappable {
    
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
