//
//  LoginModel.swift
//  Pecomy
//
//  Created by Kenzo on 2016/05/02.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import KeychainAccess

class LoginModel {
//    var pecomyToken = String()
//    var userName = String()
    
    private var session: PecomyApiClient.Session?
    
    init() {
    }
    
    func fetch(fbAccessToken: String, handler: ((PecomyResult<PecomyUser, PecomyApiClientError>) -> Void)) -> Bool {
        let request = LoginRequest(fbAccessToken: fbAccessToken)
        self.session = PecomyApiClient.send(request) {[weak self] (response: PecomyResult<LoginRequest.Response, PecomyApiClientError>) -> Void in
            guard let strongSelf = self else { return }
            switch response {
            case .Success(let value):
                //strongSelf.pecomyToken = value.pecomyUser.accessToken
                KeychainManager.setPecomyUserToken(value.pecomyUser.accessToken)
                
                handler(PecomyResult(value: value.pecomyUser))
            case .Failure(let error):
                handler(PecomyResult(error: error))
            }
            strongSelf.session = nil
        }
        return true
    }
    
    func currentPecomyToken() -> String? {
        return KeychainManager.getPecomyUserToken()
    }
    
    func isLoggedIn() -> Bool {
        return KeychainManager.getPecomyUserToken() != nil
    }

}

