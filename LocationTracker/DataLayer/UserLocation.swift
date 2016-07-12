//
//  UserLocation.swift
//  LocationTracker
//
//  Created by KhrystynaShevchuk on 7/6/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import UIKit
import CoreLocation

typealias LocationUpdateHandler = (location: CLLocation?) -> Void
typealias LocationDidFailHandler = (error: NSError) -> Void

let NOTIFICATION_UPDATE_LOCATION = "locationUpdate"
let NOTIFICATION_TRACK_DISTANCE = "trackDistanceBetweenTwoLastLocations"
let NOTIFICATION_ERROR = "error"

class UserLocation: NSObject {
    
    private struct Handlers {
        var locationUpdateHandler: LocationUpdateHandler
        var locationDidFailHandler: LocationDidFailHandler?
    }
    
    static var sharedInstance = UserLocation()
    
    private let locationManager = CLLocationManager()
    
    private var locationHandlers = [NSObject : Handlers]()
    
    var coordinates: String = ""
    var distance: Double = 0
    var distanceRestriction: Double?
    var startUserLocation: CLLocation?
    
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
    
    func getAddressByCoordinates(location: CLLocation, completion: (address: Address)->Void) {
        coordinates = ""
        coordinates += "Latitude -  \(location.coordinate.latitude)\nLongitude -  \(location.coordinate.longitude)\n"
        
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark?
            placeMark = placemarks?[0]
            
            // Address dictionary
            if placeMark != nil {
                print(placeMark!.addressDictionary)
            }
            
            if let dictionary = placeMark?.addressDictionary {
                let address = Address(dictionary: dictionary)
                completion(address: address)
            }
        })
    }
}

extension UserLocation: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName(NOTIFICATION_UPDATE_LOCATION, object: self,
                                                                  userInfo: ["location" : location])
        
        if startUserLocation == nil {
            startUserLocation = location
            return
        }
        
        guard let startUserLocation = startUserLocation else {
            return
        }
        
        distance = location.distanceFromLocation(startUserLocation)
        if distance > distanceRestriction {
            NSNotificationCenter.defaultCenter().postNotificationName(NOTIFICATION_TRACK_DISTANCE, object: self)
            self.startUserLocation = location
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("didFailWithError: \(error.description)")
       
        NSNotificationCenter.defaultCenter().postNotificationName(NOTIFICATION_ERROR, object: self)
    }
}