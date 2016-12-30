//
//  ResultModel.swift
//  Pecomy
//
//  Created by 韮澤賢三 on 2016/01/07.
//  Copyright © 2016 Pecomy. All rights reserved.
//

class ResultModel {
    var results = [Restaurant]()
    
    fileprivate var session: PecomyApiClient.Session?
    
    init() {
    }
    
    func fetch(_ latitude: Double, longitude: Double, handler: @escaping ((PecomyResult<ResultRequest.Response, PecomyApiClientError>) -> Void)) {
        let request = ResultRequest(latitude: latitude, longitude: longitude)
        self.session = PecomyApiClient.send(request) {[weak self] (response: PecomyResult<ResultRequest.Response, PecomyApiClientError>) -> Void in
            guard let strongSelf = self else { return }
            switch response {
            case .success(let value):
                strongSelf.results = value.results
                handler(PecomyResult(value: value))
            case .failure(let error):
                // TODO: エラーコードによってエラーメッセージ詰めたりする
                handler(PecomyResult(error: error))
            }
            strongSelf.session = nil
        }
        return
    }

}
