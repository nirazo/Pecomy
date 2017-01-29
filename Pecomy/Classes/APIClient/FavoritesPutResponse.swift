//
//  FavoritesPutResponse.swift
//  Pecomy
//
//  Created by Kenzo on 7/9/16.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import Foundation
import ObjectMapper

class FavoritesPutResponse: PecomyApiResponse {
    let pecomyUser = PecomyUser.sharedInstance
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        //self.pecomyUser.visits <- map["visits"]
    }
}
