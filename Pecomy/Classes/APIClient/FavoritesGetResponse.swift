//
//  FavoritesResponse.swift
//  Pecomy
//
//  Created by Kenzo on 6/19/16.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import Foundation
import ObjectMapper

class FavoritesGetResponse: PecomyApiResponse {
    internal var pecomyUser = PecomyUser.sharedInstance
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        self.pecomyUser.favorites <- map["favorites"]
    }
}
