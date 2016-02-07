//
//  CardRequest.swift
//  Karuta
//
//  Created by 韮澤賢三 on 2016/01/06.
//  Copyright © 2016年 Karuta. All rights reserved.
//

import Foundation
import Alamofire

class CardRequest: KarutaApiRequest {
    typealias Response = CardResponse
        
    var endpoint: String
    var method: Alamofire.Method = Method.GET
    var params: [String: AnyObject] = [:]
    var encoding: ParameterEncoding = ParameterEncoding.URL
    
    
    init(latitude: Double, longitude: Double, like: String? = nil, maxBudget: Budget = .LessThanThousand, numOfPeople: NumOfPeople = .One, genre: Genre = .All, syncId: String? = nil, reset: Bool = false) {
        endpoint = "card"
        params = [
            "device_id" : Utils.acquireDeviceID(),
            "latitude" : latitude,
            "longitude" : longitude,
            "reset" : reset,
        ]
        if let syncId = syncId {
            params["sync_id"] = syncId
        }
        if let like = like {
            params["answer"] = like
        }
        if (genre != .All) {
            params["select_category_group"] = genre.valueForReq()
        }
        if (maxBudget != .Nothing) {
            params["onetime_price_max"] = maxBudget.valueForReq()
        }

    }
}
