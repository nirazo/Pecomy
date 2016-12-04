//
//  CardRequest.swift
//  Pecomy
//
//  Created by 韮澤賢三 on 2016/01/06.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import Foundation
import Alamofire

class CardRequest: PecomyApiRequest {
    typealias Response = CardResponse
        
    var endpoint: String
    var method: HTTPMethod = .get
    var params: [String: Any] = [:]
    var encoding: ParameterEncoding = URLEncoding.default
    
    
    init(latitude: Double, longitude: Double, like: String? = nil, maxBudget: Budget = .unspecified, numOfPeople: NumOfPeople = .one, genre: Genre = .all, syncId: String? = nil, reset: Bool = false) {
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
        if (genre != .all) {
            params["select_category_group"] = self.genreRequestValue(genre)
        }
        if (maxBudget != .unspecified) {
            params["onetime_price_max"] = self.budgetRequestValue(maxBudget)
        }
    }
    
    //MARK:- Request param's value string for each query
    fileprivate func budgetRequestValue(_ budget: Budget) -> String {
        switch budget {
        case .unspecified:
            return ""
        case .lessThanThousand:
            return "1000"
        case .lessThanTwoThousand:
            return "2000"
        default:
            return ""
        }
    }
    
    fileprivate func genreRequestValue(_ genre: Genre) -> String {
        switch genre {
        case .all:
            return "all"
        case .cafe:
            return "cafe"
        case .drinking:
            return "drinking"
        case .restaurant:
            return "restaurant"
//        case .Ramen:
//            return "ramen"
        default:
            return ""
        }
    }
    
    fileprivate func numOfPeopleRequestValue(_ numOfpeople: NumOfPeople) -> String {
        switch numOfpeople {
        case .one:
            return "1"
        case .two:
            return "2"
        case .moreThanThree:
            return ""
        default:
            return ""
        }
    }
}
