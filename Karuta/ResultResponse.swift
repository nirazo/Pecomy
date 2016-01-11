//
//  ResultResponse.swift
//  Karuta
//
//  Created by 韮澤賢三 on 2016/01/06.
//  Copyright © 2016年 Karuta. All rights reserved.
//

import Foundation
import ObjectMapper

class ResultResponse: KarutaApiResponse {
    public var results = [Restaurant]()
    
    required public init?(_ map: Map) {
        super.init(map)
    }
    
    override public func mapping(map: Map) {
        super.mapping(map)
        self.results <- map["results"]
    }
}
