//
//  VisitsModel.swift
//  Pecomy
//
//  Created by Kenzo on 6/19/16.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import Foundation

class VisitsModel {
    
    fileprivate var session: PecomyApiClient.Session?
    
    init() {
    }
    
    func fetch(_ latitude: Double, longitude: Double, orderBy: RestaurantListOrder, handler: @escaping ((PecomyResult<PecomyUser, PecomyApiClientError>) -> Void)) {
        let request = VisitsGetRequest(latitude: latitude, longitude: longitude, orderBy: orderBy)
        self.session = PecomyApiClient.send(request) { [weak self] (response: PecomyResult<VisitsGetRequest.Response, PecomyApiClientError>) -> Void in
            guard let strongSelf = self else { return }
            
            switch response {
            case .success(let value):
                handler(PecomyResult(value: value.pecomyUser))
            case .failure(let error):
                // TODO: エラーコードによってエラーメッセージ詰めたりする
                handler(PecomyResult(error: error))
            }
            strongSelf.session = nil
        }
        return
    }
    
    func register(_ shopId: Int, reviewScore: Int, handler: @escaping ((PecomyResult<PecomyApiResponse, PecomyApiClientError>) -> Void)) {
        let request = VisitsPostRequest(shopID: shopId, reviewScore: reviewScore)
        self.session = PecomyApiClient.send(request) { [weak self] (response: PecomyResult<VisitsPostRequest.Response, PecomyApiClientError>) -> Void in
            guard let strongSelf = self else { return }
            
            switch response {
            case .success(let response):
                handler(PecomyResult(value: response))
            case .failure(let error):
                // TODO: エラーコードによってエラーメッセージ詰めたりする
                handler(PecomyResult(error: error))
            }
            strongSelf.session = nil
        }
        return
    }
}
