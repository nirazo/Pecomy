//
//  ResultRequest.swift
//  Pecomy
//
//  Created by 韮澤賢三 on 2016/01/06.
//  Copyright © 2016年 Pecomy. All rights reserved.
//

import Foundation
import Alamofire

class ResultRequest: PecomyApiRequest {
    typealias Response = ResultResponse
    
    var endpoint: String
    var method: Alamofire.Method = Method.GET
    var params: [String: AnyObject] = [:]
    var encoding: ParameterEncoding = ParameterEncoding.URL
    
    init(latitude: Double, longitude: Double) {
        endpoint = "results"
        params = [
            "device_id": Utils.acquireDeviceID(),
            "latitude" : latitude,
            "longitude" : longitude
        ]
    }

}
