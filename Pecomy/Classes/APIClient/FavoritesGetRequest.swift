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
    var method: HTTPMethod = .get
    var params: [String: Any] = [:]
    var encoding: ParameterEncoding = URLEncoding.default
    
    init(latitude: Double, longitude: Double, orderBy: RestaurantListOrder) {
        endpoint = "/user/favorites"
        params = [
            "device_id": Utils.acquireDeviceID(),
            "latitude": latitude,
            "longitude": longitude,
            "orderby": orderBy.rawValue
        ]
    }
}
