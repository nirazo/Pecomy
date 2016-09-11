//
//  BrowsesModel.swift
//  Pecomy
//
//  Created by Kenzo on 6/19/16.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import Foundation

class BrowsesModel {
    
    private var session: PecomyApiClient.Session?
    
    init() {
    }
    
    func fetch(latitude: Double, longitude: Double, orderBy: RestaurantListOrder, handler: ((PecomyResult<[Restaurant], PecomyApiClientError>) -> Void)) -> Bool {
        let request = BrowsesGetRequest(latitude: latitude, longitude: longitude, orderBy: orderBy)
        self.session = PecomyApiClient.send(request) { [weak self] (response: PecomyResult<BrowsesGetRequest.Response, PecomyApiClientError>) -> Void in
            guard let strongSelf = self else { return }
            
            switch response {
            case .Success(let value):
                handler(PecomyResult(value: value.browses))
            case .Failure(let error):
                // TODO: エラーコードによってエラーメッセージ詰めたりする
                handler(PecomyResult(error: error))
            }
            strongSelf.session = nil
        }
        return true
    }
    
    func register(shopId shopId: Int, handler: ((PecomyResult<PecomyApiResponse, PecomyApiClientError>) -> Void)) -> Bool {
        let request = BrowsesPutRequest(shopID: shopId)
        self.session = PecomyApiClient.send(request) { [weak self] (response: PecomyResult<BrowsesPutRequest.Response, PecomyApiClientError>) -> Void in
            guard let strongSelf = self else { return }
            
            switch response {
            case .Success(let response):
                handler(PecomyResult(value: response))
            case .Failure(let error):
                // TODO: エラーコードによってエラーメッセージ詰めたりする
                handler(PecomyResult(error: error))
            }
            strongSelf.session = nil
        }
        return true
    }
}
