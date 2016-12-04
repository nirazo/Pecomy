//
//  VisitsPostRequest.swift
//  Pecomy
//
//  Created by Kenzo on 7/9/16.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import Foundation
import Alamofire

class VisitsPostRequest: PecomyApiRequest {
    typealias Response = VisitsPostResponse
    
    var endpoint: String
    var method: HTTPMethod = .post
    var params: [String: Any] = [:]
    var encoding: ParameterEncoding = URLEncoding.default
    
    init(shopID: Int, reviewScore: Int) {
        endpoint = "user/visits"
        params = [
            "device_id": Utils.acquireDeviceID(),
            "shop_id": shopID,
            "review_score": reviewScore
        ]
    }
}
