//
//  LoginModel.swift
//  Pecomy
//
//  Created by Kenzo on 2016/05/02.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import KeychainAccess
import FBSDKCoreKit


class LoginModel {
    
    fileprivate var session: PecomyApiClient.Session?
    
    init() {
    }
    
    func fetch(_ fbAccessToken: String, handler: @escaping ((PecomyResult<PecomyUser, PecomyApiClientError>) -> Void)) -> Bool {
        let request = LoginRequest(fbAccessToken: fbAccessToken)
        self.session = PecomyApiClient.send(request) {[weak self] (response: PecomyResult<LoginRequest.Response, PecomyApiClientError>) -> Void in
            guard let strongSelf = self else { return }
            switch response {
            case .success(let value):
                KeychainManager.setPecomyUserToken(value.pecomyUser.accessToken)
                KeychainManager.setPecomyUserName(value.pecomyUser.userName)
                KeychainManager.setPecomyUserPictureUrl(value.pecomyUser.pictureUrl)
                //print("pecomyToken: \(value.pecomyUser.accessToken)")
                //print("deviceID: \(Utils.acquireDeviceID())")
                
                handler(PecomyResult(value: value.pecomyUser))
            case .failure(let error):
                handler(PecomyResult(error: error))
            }
            strongSelf.session = nil
        }
        return true
    }
    
    class func currentPecomyToken() -> String? {
        return KeychainManager.getPecomyUserToken()
    }
    
    class func isLoggedIn() -> Bool {
        return FBSDKAccessToken.current() != nil
    }

}

