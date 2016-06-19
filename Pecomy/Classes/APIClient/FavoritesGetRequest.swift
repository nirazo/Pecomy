//
//  FavoritesRequest.swift
//  Pecomy
//
//  Created by Kenzo on 6/19/16.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import Foundation
import Alamofire

class FavoritesGetRequest: PecomyApiRequest {
    typealias Response = FavoritesGetResponse
    
    var endpoint: String
    var method: Alamofire.Method = .POST
    var params: [String: AnyObject] = [:]
    var encoding: ParameterEncoding = .URL
    
    init(prcomyAccessToken: String, latitude: Double, longitude: Double, orderBy: RestaurantListOrder) {
        endpoint = "user/favorites"
        params = [
            "access_token" : prcomyAccessToken,
            "device_id": Utils.acquireDeviceID(),
            "latitude": latitude,
            "longitude": longitude,
            "orderby": orderBy.rawValue
        ]
    }
}