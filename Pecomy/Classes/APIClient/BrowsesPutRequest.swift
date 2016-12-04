//
//  BrowsesPutRequest.swift
//  Pecomy
//
//  Created by Kenzo on 6/19/16.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import Foundation
import Alamofire

class BrowsesPutRequest: PecomyApiRequest {
    typealias Response = BrowsesPutResponse
    
    var endpoint: String
    var method: HTTPMethod = .put
    var params: [String: Any] = [:]
    var encoding: ParameterEncoding = URLEncoding.default
    
    init(shopID: Int) {
        endpoint = "/user/browses"
        params = [
            "device_id": Utils.acquireDeviceID(),
            "shop_id": shopID
        ]
    }
}
