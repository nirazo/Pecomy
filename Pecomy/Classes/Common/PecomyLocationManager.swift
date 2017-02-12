//
//  PecomyLocationManager.swift
//  Pecomy
//
//  Created by Kenzo on 2015/06/22.
//  Copyright (c) 2016 Pecomy. All rights reserved.
//

import UIKit
import CoreLocation

//possible errors
enum PecomyLocationManagerErrors: Int {
    case authorizationDenied
    case authorizationNotDetermined
    case invalidLocation
}

protocol PecomyLocationManagerDelegate {
    func showLocationEnableAlert()
}

class PecomyLocationManager: NSObject, CLLocationManagerDelegate {
    
    fileprivate var locationManager: CLLocationManager?
    var delegate: PecomyLocationManagerDelegate!
    
    deinit {
        locationManager?.delegate = nil
        locationManager = nil
    }
    
    typealias LocationClosure = (CLLocation?) -> Void
    typealias LocationErrorClosure = (Error?) -> Void
    fileprivate var didCompleteWithSuccess: LocationClosure?
    fileprivate var didCompleteWithFailure: LocationErrorClosure?
    
    
    fileprivate func didCompleteWithSuccess(_ location: CLLocation?) {
        locationManager?.stopUpdatingLocation()
        let ud = UserDefaults.standard
        if ud.bool(forKey: Const.isFixLocationKey) { // Debugモードで位置情報固定時
            let stubLocation = CLLocation(latitude: Const.fixedLatitude, longitude: Const.fixedLongitude)
            didCompleteWithSuccess?(stubLocation)
        } else {
            didCompleteWithSuccess?(location)
        }
        locationManager?.delegate = nil
        locationManager = nil
    }
    
    fileprivate func didCompleteWithError(_ error: Error?) {
        locationManager?.stopUpdatingLocation()
        let ud = UserDefaults.standard
        if ud.bool(forKey: Const.isFixLocationKey) { // Debugモードで位置情報固定時
            let stubLocation = CLLocation(latitude: Const.fixedLatitude, longitude: Const.fixedLongitude)
            didCompleteWithSuccess?(stubLocation)
        } else {
            didCompleteWithFailure?(error)
        }
        locationManager?.delegate = nil
        locationManager = nil
    }
    
    internal func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            self.requestPermission()
            break
        case .authorizedWhenInUse, .authorizedAlways:
            self.locationManager!.startUpdatingLocation()
            break
        case .denied, .restricted:
            self.delegate.showLocationEnableAlert()
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        didCompleteWithError(error)
    }
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            if (-(location.timestamp.timeIntervalSinceNow) < 15.0) {
                didCompleteWithSuccess(location)
            }
        } else {
            didCompleteWithError(NSError(domain: self.classForCoder.description(),
                code: PecomyLocationManagerErrors.invalidLocation.rawValue,
                userInfo: nil))
        }
    }
    
    func fetchWithCompletion(_ success: @escaping LocationClosure, failure: @escaping LocationErrorClosure) {
        
        if (!CLLocationManager.locationServicesEnabled()) {
            delegate.showLocationEnableAlert()
            return
        }
        
        didCompleteWithSuccess = success
        didCompleteWithFailure = failure
        
        locationManager = CLLocationManager()
        locationManager!.delegate = self
    }
    
    
    fileprivate func requestPermission() {
        if (Bundle.main.object(forInfoDictionaryKey: "NSLocationWhenInUseUsageDescription") != nil) {
            locationManager!.requestWhenInUseAuthorization()
        } else if (Bundle.main.object(forInfoDictionaryKey: "NSLocationAlwaysUsageDescription") != nil) {
            locationManager!.requestAlwaysAuthorization()
        } else {
            fatalError("To use location in iOS8 you need to define either NSLocationWhenInUseUsageDescription or NSLocationAlwaysUsageDescription in the app bundle's Info.plist file")
        }

    }
    
}
