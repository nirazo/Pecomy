//
//  Restaurant.swift
//  Karuta
//
//  Created by Kenzo on 2015/07/26.
//  Copyright (c) 2015年 Karuta. All rights reserved.
//

class RestaurantModel {
    var restaurant = Restaurant()
    var syncID = ""
    var resultAvailable = false
    
    private var session: KarutaApiClient.Session?
    
    init() {
    }
    
    func fetch(latitude: Double, longitude: Double, like: String? = nil, category: CategoryIdentifier, syncId: String? = nil, reset: Bool, handler: ((KarutaResult<Restaurant, KarutaApiClientError>) -> Void)) -> Bool {
        let request = CardRequest(latitude: latitude, longitude: longitude, like: like, category: category, syncId: syncId, reset: reset)
        self.session = KarutaApiClient.send(request) {[weak self] (response: KarutaResult<CardRequest.Response, KarutaApiClientError>) -> Void in
            guard let strongSelf = self else {
                return
            }
            
            switch response {
            case .Success(let value):
                strongSelf.restaurant = value.restaurant
                strongSelf.syncID = value.syncID
                strongSelf.resultAvailable = value.resultAvailable
                handler(KarutaResult(value: value.restaurant))
            case .Failure(let error):
                //Log.d(error)
                handler(KarutaResult(error: error))
            }
            
            strongSelf.session = nil
        }
        return true
    }
}
