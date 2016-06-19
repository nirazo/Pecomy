//
//  VisitsGetRequest.swift
//  Pecomy
//
//  Created by Kenzo on 6/19/16.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import Foundation
import Alamofire

class VisitsGetRequest: PecomyApiRequest {
    typealias Response = VisitsGetResponse
    
    var endpoint: String
    var method: Alamofire.Method = .GET
    var params: [String: AnyObject] = [:]
    var encoding: ParameterEncoding = .URL
    
    init(latitude: Double, longitude: Double, orderBy: RestaurantListOrder) {
        endpoint = "/user/visits"
        params = [
            "device_id": Utils.acquireDeviceID(),
            "latitude": latitude,
            "longitude": longitude,
            "orderby": orderBy.rawValue
        ]
    }
}