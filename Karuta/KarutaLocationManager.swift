//
//  KarutaLocationManager.swift
//  Karuta
//
//  Created by Kenzo on 2015/06/22.
//  Copyright (c) 2015年 Karuta. All rights reserved.
//

import UIKit
import CoreLocation

//possible errors
enum KarutaLocationManagerErrors: Int {
    case AuthorizationDenied
    case AuthorizationNotDetermined
    case InvalidLocation
}

protocol KarutaLocationManagerDelegate {
    func showLocationEnableAlert()
}

class KarutaLocationManager: NSObject, CLLocationManagerDelegate {
    
    private var locationManager: CLLocationManager?
    var delegate: KarutaLocationManagerDelegate!
    
    deinit {
        locationManager?.delegate = nil
        locationManager = nil
    }
    
    typealias LocationClosure = (location: CLLocation?)->()
    typealias LocationErrorClosure = (error: NSError?)->()
    private var didCompleteWithSuccess = LocationClosure?()
    private var didCompleteWithFailure = LocationErrorClosure?()
    
    
    private func didCompleteWithSuccess(location: CLLocation?) {
        locationManager?.stopUpdatingLocation()
        #if FIXED_LOCATION
            var stubLocation = CLLocation(latitude: Const.FIXED_LATITUDE, longitude: Const.FIXED_LONGITUDE)
            didCompleteWithSuccess?(location: stubLocation)
        #else
            didCompleteWithSuccess?(location: location)
        #endif
        locationManager?.delegate = nil
        locationManager = nil
    }
    
    private func didCompleteWithError(error: NSError?) {
        locationManager?.stopUpdatingLocation()
        #if FIXED_LOCATION
            var stubLocation = CLLocation(latitude: Const.FIXED_LATITUDE, longitude: Const.FIXED_LONGITUDE)
            didCompleteWithSuccess?(location: stubLocation)
        #else
            didCompleteWithFailure?(error: error)
        #endif
        locationManager?.delegate = nil
        locationManager = nil
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .AuthorizedWhenInUse:
            self.locationManager!.startUpdatingLocation()
        case .Denied:
            self.delegate.showLocationEnableAlert()
        default:
            locationManager!.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        didCompleteWithError(error)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let location = locations[0] as? CLLocation {
            if (-(location.timestamp.timeIntervalSinceNow) < 15.0) {
                didCompleteWithSuccess(location)
            }
        } else {
            didCompleteWithError(NSError(domain: self.classForCoder.description(),
                code: KarutaLocationManagerErrors.InvalidLocation.rawValue,
                userInfo: nil))
        }
    }
    
    func fetchWithCompletion(success: LocationClosure, failure: LocationErrorClosure) {
        
        if (!CLLocationManager.locationServicesEnabled()) {
            delegate.showLocationEnableAlert()
            return
        }
        
        didCompleteWithSuccess = success
        didCompleteWithFailure = failure
        
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        
        if (NSBundle.mainBundle().objectForInfoDictionaryKey("NSLocationWhenInUseUsageDescription") != nil) {
            locationManager!.requestWhenInUseAuthorization()
        } else if (NSBundle.mainBundle().objectForInfoDictionaryKey("NSLocationAlwaysUsageDescription") != nil) {
            locationManager!.requestAlwaysAuthorization()
        } else {
            fatalError("To use location in iOS8 you need to define either NSLocationWhenInUseUsageDescription or NSLocationAlwaysUsageDescription in the app bundle's Info.plist file")
        }
    }
    
}
