//
//  CardResponse.swift
//  Pecomy
//
//  Created by 韮澤賢三 on 2016/01/06.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import Foundation
import ObjectMapper

class CardResponse: PecomyApiResponse {
    var restaurant = Restaurant()
    var syncID = ""
    var resultAvailable = false
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        self.restaurant <- map["card"]
        self.syncID <- map["sync_id"]
        self.resultAvailable <- map["result_available"]
    }
}
