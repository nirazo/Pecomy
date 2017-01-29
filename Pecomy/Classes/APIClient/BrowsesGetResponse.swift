//
//  BrowsesResponse.swift
//  Pecomy
//
//  Created by Kenzo on 6/18/16.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import Foundation
import ObjectMapper

class BrowsesGetResponse: PecomyApiResponse {
    internal var pecomyUser = PecomyUser.sharedInstance
    internal var browses = [Restaurant]()
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        self.pecomyUser.browses <- map["browses"]
        self.browses <- map["browses"]
    }
}
