//
//  LoginModel.swift
//  Pecomy
//
//  Created by Kenzo on 2016/05/02.
//  Copyright © 2016年 Pecomy. All rights reserved.
//

import KeychainAccess

class LoginModel {
    var pecomyToken = String()
    
    private var session: PecomyApiClient.Session?
    
    init() {
    }
    
    func fetch(fbAccessToken: String, handler: ((PecomyResult<String, PecomyApiClientError>) -> Void)) -> Bool {
        let request = LoginRequest(fbAccessToken: fbAccessToken)
        self.session = PecomyApiClient.send(request) {[weak self] (response: PecomyResult<LoginRequest.Response, PecomyApiClientError>) -> Void in
            guard let strongSelf = self else { return }
            switch response {
            case .Success(let value):
                strongSelf.pecomyToken = value.pecomyToken
                
                KeychainManager.setStringValue(strongSelf.pecomyToken, key: Const.UserTokenKeychainKey)
                
                handler(PecomyResult(value: value.pecomyToken))
            case .Failure(let error):
                handler(PecomyResult(error: error))
            }
            strongSelf.session = nil
        }
        return true
    }
    
    func currentPecomyToken() -> String? {
        return KeychainManager.getStringValue(Const.UserTokenKeychainKey)
    }
    
    func isLoggedIn() -> Bool {
        return KeychainManager.getStringValue(Const.UserTokenKeychainKey) != nil
    }

}

