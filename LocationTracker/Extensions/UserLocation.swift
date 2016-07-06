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
    
    static let sharedInstance = UserLocation()
    let locationManager = CLLocationManager()
    var currentAddress: String = ""
    
    override init() {
        super.init()
        setupLocation()
    }

    func setupLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
    }
}

extension UserLocation: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //todo - notify about coordinate changed nsnotificationmanager
        
        

    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("didFailWithError: \(error.description)")
        
        //todo - notify about error

    }
}