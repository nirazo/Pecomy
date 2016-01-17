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
    internal var results = [Restaurant]()
    
    required init?(_ map: Map) {
        super.init(map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map)
        self.results <- map["results"]
    }
}
