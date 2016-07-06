//
//  UserLocation.swift
//  LocationTracker
//
//  Created by KhrystynaShevchuk on 7/6/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class UserLocation: NSObject {
    
    static var sharedInstance: UserLocation {
        struct Static {
            static var sharedInstance: UserLocation?
            static var token: dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
            Static.sharedInstance = UserLocation()
        }
        return Static.sharedInstance!
    }
    
    private let locationManager = CLLocationManager()
    
    
//    static var sharedInstance = UserLocation()
    
    
    var locationDidUpdateHandler: ((location: CLLocation?)->Void)?
    var locationDidFailHandler: ((error: NSError)->Void)?
    
    
    private override init() {
        super.init()
        
        setupLocation()
    }
    
    var currentLocation: CLLocation? {
        return locationManager.location
    }
    
    var isAuthorized: Bool {
        return CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse
    }

    func setupLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        requestForAuthorization()
        
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.startUpdatingLocation()
    }
    
    func requestForAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
}

extension UserLocation: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        locationDidUpdateHandler?(location: currentLocation)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("didFailWithError: \(error.description)")
        
        //todo - notify about error
        locationDidFailHandler?(error: error)
    }
}