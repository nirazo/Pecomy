//
//  KeyChainManager.swift
//  Pecomy
//
//  Created by Kenzo on 2016/05/02.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import Foundation
import KeychainAccess

class KeychainManager {
    private static let keychain = Keychain()
    
    static func setPecomyUserToken(token: String) {
        do {
          try self.keychain.set(token, key: Const.PecomyUserTokenKeychainKey)
        } catch let error {
            fatalError("Keychain error: failed to set pecomy user token value(\(token)) to key(\(Const.PecomyUserTokenKeychainKey)) : \(error)")
        }
    }
    
    static func getPecomyUserToken() -> String? {
        do {
            return try self.keychain.getString(Const.PecomyUserTokenKeychainKey)
        } catch let error {
            fatalError("Keychain Error: failed to get pecomy user token value for key(\(Const.PecomyUserTokenKeychainKey)) : \(error)")
        }
    }
    
    static func removePecomyUserToken() {
        do {
            try self.keychain.remove(Const.PecomyUserTokenKeychainKey)
        } catch let error {
            fatalError("Keychain Error: failed to remove pecomy user token value for key(\(Const.PecomyUserTokenKeychainKey)) : \(error)")
        }
    }
    
}
