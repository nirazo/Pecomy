//
//  Restaurant.swift
//  Karuta
//
//  Created by Kenzo on 2015/07/26.
//  Copyright (c) 2015年 Karuta. All rights reserved.
//

class RestaurantModel {
    public var restaurant = Restaurant()
    public var syncID = ""
    public var resultAvailable = false
    
    private var session: KarutaApiClient.Session?
    
    init() {
    }
    
    public func fetch(latitude: Double, longitude: Double, like: String? = nil, category: CategoryIdentifier, syncId: String? = nil, reset: Bool, handler: ((KarutaResult<Restaurant, KarutaApiClientError>) -> Void)) -> Bool {
        let request = CardRequest(latitude: latitude, longitude: longitude, like: like, category: category, syncId: syncId, reset: reset)
        self.session = KarutaApiClient.send(request) {[weak self] (response: KarutaResult<CardRequest.Response, KarutaApiClientError>) -> Void in
            guard let weakSelf = self else {
                return
            }
            
            switch response {
            case .Success(let value):
                weakSelf.restaurant = value.restaurant
                weakSelf.syncID = value.syncID
                weakSelf.resultAvailable = value.resultAvailable
                handler(KarutaResult(value: value.restaurant))
            case .Failure(let error):
                //Log.d(error)
                handler(KarutaResult(error: error))
            }
            
            weakSelf.session = nil
        }
        return true
    }
}
