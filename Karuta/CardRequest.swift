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
    
    
    init(latitude: Double, longitude: Double, like: String? = nil, maxBudget: Budget = .Unspecified, numOfPeople: NumOfPeople = .One, genre: Genre = .All, syncId: String? = nil, reset: Bool = false) {
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
            params["select_category_group"] = self.genreRequestValue(genre)
        }
        if (maxBudget != .Unspecified) {
            params["onetime_price_max"] = self.budgetRequestValue(maxBudget)
        }
    }
    
    //MARK:- Request param's value string for each query
    private func budgetRequestValue(budget: Budget) -> String {
        switch budget {
        case .Unspecified:
            return ""
        case .LessThanThousand:
            return "1000"
        case .LessThanTwoThousand:
            return "2000"
        default:
            return ""
        }
    }
    
    private func genreRequestValue(genre: Genre) -> String {
        switch genre {
        case .All:
            return "all"
        case .Cafe:
            return "cafe"
        case .Drinking:
            return "drinking"
        case .Restaurant:
            return "restaurant"
        case .Ramen:
            return "ramen"
        default:
            return ""
        }
    }
    
    private func numOfPeopleRequestValue(numOfpeople: NumOfPeople) -> String {
        switch numOfpeople {
        case .One:
            return "1"
        case .Two:
            return "2"
        case .MoreThanThree:
            return ""
        default:
            return ""
        }
    }
}
