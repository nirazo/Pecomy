//
//  FavoritesPutRequest.swift
//  Pecomy
//
//  Created by Kenzo on 7/9/16.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import Foundation
import Alamofire

class FavoritesPutRequest: PecomyApiRequest {
    typealias Response = FavoritesPutResponse
    
    var endpoint: String
    var method: HTTPMethod = .put
    var params: [String: Any] = [:]
    var encoding: ParameterEncoding = URLEncoding.default
    
    init(shopID: Int) {
        endpoint = "/user/favorites"
        params = [
            "device_id": Utils.acquireDeviceID(),
            "shop_id": shopID
        ]
    }
}
