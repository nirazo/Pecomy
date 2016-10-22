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
    var method: Alamofire.Method = .PUT
    var params: [String: AnyObject] = [:]
    var encoding: ParameterEncoding = .URL
    
    init(shopID: Int) {
        endpoint = "/user/browses"
        params = [
            "device_id": Utils.acquireDeviceID(),
            "shop_id": shopID
        ]
    }
}