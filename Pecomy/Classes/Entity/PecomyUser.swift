//
//  PecomyUser.swift
//  Pecomy
//
//  Created by Kenzo on 5/29/16.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import Foundation
import Foundation
import ObjectMapper

class PecomyUser {
    static let sharedInstance = PecomyUser()
    var accessToken = ""
    var userName = ""
    var pictureUrl = ""
    var browses = [Restaurant]()
    var favorites = [Restaurant]()
    var visits = [Restaurant]()
    
    fileprivate init() {
    }
}
