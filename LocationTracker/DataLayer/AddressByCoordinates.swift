//
//  AddressByCoordinates.swift
//  LocationTracker
//
//  Created by KhrystynaShevchuk on 7/6/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import UIKit
import CoreLocation

class AddressByCoordinates {
    
//    private static var _sharedInstance: AddressByCoordinates?
//    
//    static var sharedInstance: AddressByCoordinates {
//        if _sharedInstance == nil {
//            _sharedInstance = AddressByCoordinates()
//        }
//        return _sharedInstance!
//    }
    
//    static let sharedInstance = AddressByCoordinates()
    
    static var sharedInstance: AddressByCoordinates {
        struct Static {
            static var sharedInstance: AddressByCoordinates?  // places reference of current singletone
            static var token: dispatch_once_t = 0   // gives guarantee of only one initialisation (dispatch_once_t = 0)
        }
        dispatch_once(&Static.token) {  // set value just once
            Static.sharedInstance = AddressByCoordinates()
        }
        return Static.sharedInstance!
    }
    
    private init() {}
    
    
    func getAddressByCoordinates(location: CLLocation, completion: (address: Address)->Void) {
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