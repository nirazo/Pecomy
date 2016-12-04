//
//  ResultResponse.swift
//  Pecomy
//
//  Created by 韮澤賢三 on 2016/01/06.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import Foundation
import ObjectMapper

class ResultResponse: PecomyApiResponse {
    internal var results = [Restaurant]()
    internal var displayMessage = ""
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        self.results <- map["results"]
        self.displayMessage <- map["message"]
    }
}
