//
//  AppState.swift
//  Pecomy
//
//  Created by Kenzo on 6/21/16.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import Foundation

class AppState {
    static let sharedInstance = AppState()
    
    var currentLatitude: Double?
    var currentLongitude: Double?
    
    private init() {
    }
}
