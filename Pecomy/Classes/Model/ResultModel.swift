//
//  ResultModel.swift
//  Pecomy
//
//  Created by 韮澤賢三 on 2016/01/07.
//  Copyright © 2016年 Pecomy. All rights reserved.
//

class ResultModel {
    var results = [Restaurant]()
    
    private var session: PecomyApiClient.Session?
    
    init() {
    }
    
    func fetch(latitude: Double, longitude: Double, handler: ((PecomyResult<[Restaurant], PecomyApiClientError>) -> Void)) -> Bool {
        let request = ResultRequest(latitude: latitude, longitude: longitude)
        self.session = PecomyApiClient.send(request) {[weak self] (response: PecomyResult<ResultRequest.Response, PecomyApiClientError>) -> Void in
            guard let strongSelf = self else {
                return
            }
            switch response {
            case .Success(let value):
                strongSelf.results = value.results
                handler(PecomyResult(value: value.results))
            case .Failure(let error):
                // TODO: エラーコードによってエラーメッセージ詰めたりする
                handler(PecomyResult(error: error))
            }
            strongSelf.session = nil
        }
        return true
    }

}
