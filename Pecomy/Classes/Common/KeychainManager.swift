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
    
    static func setStringValue(value: String, key: String) {
        do {
          try self.keychain.set(value, key: key)
        } catch let error {
            fatalError("Keychain Error: failed to write value(\(value)) to key(\(key)) : \(error)")
        }
    }
    
    static func getStringValue(key: String) -> String? {
        do {
            return try self.keychain.getString(key)
        } catch let error {
            fatalError("Keychain Error: failed to get value for key(\(key)) : \(error)")
        }
    }
    
    static func removeValue(key: String) {
        do {
            try self.keychain.remove(key)
        } catch let error {
            fatalError("Keychain Error: failed to remove value for key(\(key)) : \(error)")
        }
    }
    
}
