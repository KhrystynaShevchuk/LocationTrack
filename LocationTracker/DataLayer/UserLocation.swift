//
//  UserLocation.swift
//  LocationTracker
//
//  Created by KhrystynaShevchuk on 7/6/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import UIKit
import CoreLocation

typealias LocationUpdateHandler = (location: CLLocation?)->Void
typealias LocationDidFailHandler = (error: NSError)->Void

let NOTIFICATION_UPDATE_LICATION = "locationUpdate"
let NOTIFICATION_ERROR = "error"

class UserLocation: NSObject {
    
    private struct Handlers {
        var locationUpdateHandler: LocationUpdateHandler
        var locationDidFailHandler: LocationDidFailHandler?
    }
    
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
    
    //    static var sharedInstance = UserLocation()
    
    
    private let locationManager = CLLocationManager()
    
    
    //    var locationDidUpdateHandler: ((location: CLLocation?)->Void)?
    //    var locationDidFailHandler: ((error: NSError)->Void)?
    
    //    var locationDidUpdateHandlers = [NSObject : LocationUpdateHandler]()
    //    var locationDidFailHandlers = [NSObject : LocationDidFailHandler]()
    
    private var locationHandlers = [NSObject : Handlers]()
    
    
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
    
    
    //    func addLocationUpdateHandler(handler: LocationUpdateHandler) {
    //        locationDidUpdateHandlers.append(handler)
    //    }
    //
    //    func addlocationDidFailHandler(handler: LocationDidFailHandler) {
    //        locationDidFailHandlers.append(handler)
    //    }
    
    //    func addObserver(observer: NSObject, updateHandler: LocationUpdateHandler, failHandler: LocationDidFailHandler? = nil) {
    ////        locationDidUpdateHandlers.append([observer : updateHandler])
    ////        locationDidUpdateHandlers[observer] = updateHandler
    ////        if let failHandler = failHandler {
    ////            locationDidFailHandlers.append([observer : failHandler])
    ////            locationDidFailHandlers[observer] = failHandler
    ////        }
    //        let handlers = Handlers(locationUpdateHandler: updateHandler, locationDidFailHandler: failHandler)
    //        locationHandlers[observer] = handlers
    //    }
    
    //    func removeHandlersForObserver(observer: NSObject) {  // how to remove handler from dictionary of handlers
    ////        locationDidUpdateHandlers.removeValueForKey(observer)
    ////        locationDidFailHandlers.removeValueForKey(observer)
    //        locationHandlers.removeValueForKey(observer)
    //    }
    
    func addUpdateLocationObserver(observer: AnyObject, selector aSelector: Selector) {
        NSNotificationCenter.defaultCenter().addObserver(observer,
                                                         selector: aSelector,
                                                         name: NOTIFICATION_UPDATE_LICATION,
                                                         object: self)
    }
    
    func addErrorObserver(observer: AnyObject, selector aSelector: Selector) {
        NSNotificationCenter.defaultCenter().addObserver(observer,
                                                         selector: aSelector,
                                                         name: NOTIFICATION_ERROR,
                                                         object: self)
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
        
        //        locationDidUpdateHandler?(location: currentLocation)
        //        for (_, handler) in locationDidUpdateHandlers {
        //            handler(location: currentLocation)
        //        }
        //        for (_, handlers) in locationHandlers {
        //            handlers.locationUpdateHandler(location: currentLocation)
        //        }
        NSNotificationCenter.defaultCenter().postNotificationName(NOTIFICATION_UPDATE_LICATION, object: self,
                                                                  userInfo: ["location" : currentLocation!])
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("didFailWithError: \(error.description)")
        
        //        locationDidFailHandler?(error: error)
        //        for (_, handler) in locationDidFailHandlers {
        //            handler(error: error)
        //        }
//        for (_, handlers) in locationHandlers {
//            handlers.locationDidFailHandler?(error: error)
//        }
        NSNotificationCenter.defaultCenter().postNotificationName(NOTIFICATION_ERROR, object: self, userInfo: ["error" : error])
    }
}