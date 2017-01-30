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
    
    private var currentLat: Double?
    var currentLatitude: Double? {
        get {
            let ud = UserDefaults.standard
            if ud.bool(forKey: Const.isFixLocationKey) {
                return Const.fixedLatitude
            } else {
                return self.currentLat
            }
        }
        set(lat) {
            self.currentLat = lat
        }
    }
    
    private var currentLon: Double?
    var currentLongitude: Double? {
        get {
            let ud = UserDefaults.standard
            if ud.bool(forKey: Const.isFixLocationKey) {
                return Const.fixedLongitude
            } else {
                return self.currentLon
            }
        }
        set(lon) {
            self.currentLon = lon
        }
    }
    
    // Debug Settings
    var useFixedLocation = false
    
    fileprivate init() {
    }
}
