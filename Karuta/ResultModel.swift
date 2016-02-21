//
//  ResultModel.swift
//  Karuta
//
//  Created by 韮澤賢三 on 2016/01/07.
//  Copyright © 2016年 Karuta. All rights reserved.
//

class ResultModel {
    var results = [Restaurant]()
    
    private var session: KarutaApiClient.Session?
    
    init() {
    }
    
    func fetch(latitude: Double, longitude: Double, handler: ((KarutaResult<[Restaurant], KarutaApiClientError>) -> Void)) -> Bool {
        let request = ResultRequest(latitude: latitude, longitude: longitude)
        self.session = KarutaApiClient.send(request) {[weak self] (response: KarutaResult<ResultRequest.Response, KarutaApiClientError>) -> Void in
            guard let strongSelf = self else {
                return
            }
            switch response {
            case .Success(let value):
                strongSelf.results = value.results
                handler(KarutaResult(value: value.results))
            case .Failure(let error):
                // TODO: エラーコードによってエラーメッセージ詰めたりする
                handler(KarutaResult(error: error))
            }
            strongSelf.session = nil
        }
        return true
    }

}
