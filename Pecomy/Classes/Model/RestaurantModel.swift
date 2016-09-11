//
//  Restaurant.swift
//  Pecomy
//
//  Created by Kenzo on 2015/07/26.
//  Copyright (c) 2016 Pecomy. All rights reserved.
//

class RestaurantModel {
    var restaurant = Restaurant()
    var syncID = ""
    var resultAvailable = false
    
    private var session: PecomyApiClient.Session?
    
    init() {
    }
    
    func fetch(latitude: Double, longitude: Double, like: String? = nil, maxBudget: Budget, numOfPeople: NumOfPeople, genre: Genre, syncId: String? = nil, reset: Bool, handler: ((PecomyResult<Restaurant, PecomyApiClientError>) -> Void)) -> Bool {
        let request = CardRequest(latitude: latitude, longitude: longitude, like: like, maxBudget: maxBudget, genre: genre, syncId: syncId, reset: reset)
        request.headerParams
        self.session = PecomyApiClient.send(request) {[weak self] (response: PecomyResult<CardRequest.Response, PecomyApiClientError>) -> Void in
            guard let strongSelf = self else { return }
            
            switch response {
            case .Success(let value):
                //print("restaurant: \(value.restaurant)")
                strongSelf.restaurant = value.restaurant
                strongSelf.syncID = value.syncID
                strongSelf.resultAvailable = value.resultAvailable
                handler(PecomyResult(value: value.restaurant))
            case .Failure(let error):
                // TODO: エラーコードによってエラーメッセージ詰めたりする
                handler(PecomyResult(error: error))
            }
            
            strongSelf.session = nil
        }
        return true
    }
}
