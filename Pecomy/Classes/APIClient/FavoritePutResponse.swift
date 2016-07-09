//
//  FavoritePutResponse.swift
//  Pecomy
//
//  Created by Kenzo on 7/9/16.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import Foundation
import ObjectMapper

class FavoritePutResponse: PecomyApiResponse {
    let pecomyUser = PecomyUser.sharedInstance
    
    required init?(_ map: Map) {
        super.init(map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map)
        //self.pecomyUser.visits <- map["visits"]
    }
}