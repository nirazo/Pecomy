//
//  LoginResponse.swift
//  Pecomy
//
//  Created by Kenzo on 2016/05/02.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import Foundation
import ObjectMapper

class LoginResponse: PecomyApiResponse {
    internal var pecomyUser = PecomyUser()
    
    required init?(_ map: Map) {
        super.init(map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map)
        self.pecomyUser.accessToken <- map["access_token"]
        self.pecomyUser.userName <- map["name"]
    }
}
