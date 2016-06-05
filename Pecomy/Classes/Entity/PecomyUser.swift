//
//  PecomyUser.swift
//  Pecomy
//
//  Created by Kenzo on 5/29/16.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import Foundation
import Foundation
import ObjectMapper

struct PecomyUser {
    var accessToken = ""
    var userName = ""
}

//extension PecomyUser: Mappable {
//    init?(_ map: Map) {
//        mapping(map)
//    }
//    
//    mutating func mapping(map: Map) {
//        accessToken <- map["access_token"]
//        userName <- map["name"]
//    }
//}