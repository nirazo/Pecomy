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
    
    var code = ""
    var causes = [String]()
    
    public init() {}
    
    public required init?(_ map: Map) {
        mapping(map)
    }
    
    public func mapping(map: Map) {
        code <- map["body.code"]
        causes <- map["body.causes"]
    }
}
