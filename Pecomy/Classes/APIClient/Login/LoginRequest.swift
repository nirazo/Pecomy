//
//  LoginRequest.swift
//  Pecomy
//
//  Created by Kenzo on 2016/05/02.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import Foundation
import Alamofire

class LoginRequest: PecomyApiRequest {
    typealias Response = LoginResponse
    
    var endpoint: String
    var method: Alamofire.Method = .POST
    var params: [String: AnyObject] = [:]
    var encoding: ParameterEncoding = .URL
    
    init(fbAccessToken: String) {
        endpoint = "login"
        params = [
            "access_token" : fbAccessToken,
            "device_id": Utils.acquireDeviceID()
        ]
    }
    
}

