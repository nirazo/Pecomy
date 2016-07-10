//
//  VisitsPutResponse.swift
//  Pecomy
//
//  Created by Kenzo on 7/9/16.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import Foundation
import ObjectMapper

class VisitsPutResponse: PecomyApiResponse {
    let pecomyUser = PecomyUser.sharedInstance
    var messageString = ""
    
    required init?(_ map: Map) {
        super.init(map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map)
        self.messageString <- map["message"]
    }
}