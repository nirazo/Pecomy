//
//  BrowsesRequest.swift
//  Pecomy
//
//  Created by Kenzo on 6/18/16.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import Foundation
import Alamofire

class BrowsesGetRequest: PecomyApiRequest {
    typealias Response = BrowsesGetResponse
    
    var endpoint: String
    var method: Alamofire.Method = .GET
    var params: [String: AnyObject] = [:]
    var encoding: ParameterEncoding = .URL
    
    init(latitude: Double, longitude: Double, orderBy: RestaurantListOrder) {
        endpoint = "/user/browses"
        params = [
            "device_id": Utils.acquireDeviceID(),
            "latitude": latitude,
            "longitude": longitude,
            "orderby": orderBy.rawValue
        ]
    }
}