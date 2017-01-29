//
//  ResultRequest.swift
//  Pecomy
//
//  Created by 韮澤賢三 on 2016/01/06.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import Foundation
import Alamofire

class ResultRequest: PecomyApiRequest {
    typealias Response = ResultResponse
    
    var endpoint: String
    var method: HTTPMethod = .get
    var params: [String: Any] = [:]
    var encoding: ParameterEncoding = URLEncoding.default
    
    init(latitude: Double, longitude: Double) {
        endpoint = "results"
        params = [
            "device_id": Utils.acquireDeviceID(),
            "latitude" : latitude,
            "longitude" : longitude
        ]
    }

}
