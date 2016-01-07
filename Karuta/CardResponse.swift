//
//  CardResponse.swift
//  Karuta
//
//  Created by 韮澤賢三 on 2016/01/06.
//  Copyright © 2016年 Karuta. All rights reserved.
//

import Foundation
import ObjectMapper

class CardResponse: KarutaApiResponse {
    public var restaurant = Restaurant()
    public var syncID = ""
    public var resultAvailable = false
    
    required public init?(_ map: Map) {
        super.init(map)
    }
    
    override public func mapping(map: Map) {
        super.mapping(map)
        self.restaurant <- map["card"]
        self.syncID <- map["sync_id"]
        self.resultAvailable <- map["result_available"]
    }
}
