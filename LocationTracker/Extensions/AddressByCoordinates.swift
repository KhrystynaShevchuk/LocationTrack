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
            static var sharedInstance: AddressByCoordinates?
            static var token: dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
            Static.sharedInstance = AddressByCoordinates()
        }
        return Static.sharedInstance!
    }
    
    private init() {}
    
    
//    var currentAddress: String = ""
    
    func getAddressByCoordinates(location: CLLocation, completion: (address: String)->Void) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
//            self.currentAddress = ""
            
            var currentAddress = ""
            
            // todo - move to separate method. or model
            
            // Place details
            var placeMark: CLPlacemark?
            placeMark = placemarks?[0]
            
            // Address dictionary
            if placeMark != nil {
                print(placeMark!.addressDictionary)
            }
            
            // Street address
            if let street = placeMark?.addressDictionary!["Thoroughfare"] as? String {
                let streetValue = "STREET :  \(street)\n"
//                self.currentAddress = self.currentAddress + streetValue
                currentAddress = currentAddress + streetValue
            }
            
            // City
            if let city = placeMark?.addressDictionary!["City"] as? NSString {
                let cityValue = "CITY :    \(city)\n"
//                self.currentAddress = self.currentAddress + cityValue
                currentAddress = currentAddress + cityValue
            }
            
            // Country
            if let country = placeMark?.addressDictionary!["Country"] as? NSString {
                let countryValue = "COUNTRY :  \(country)\n"
//                self.currentAddress = self.currentAddress + countryValue
                currentAddress = currentAddress + countryValue
            }
            
            // Country code
            if let countryCode = placeMark?.addressDictionary!["CountryCode"] as? String {
                let countryCodeValue = "COUNTRY CODE :  \(countryCode)"
//                self.currentAddress = self.currentAddress + countryCodeValue
                currentAddress = currentAddress + countryCodeValue
            }
            
            completion(address: currentAddress)
        })
    }
}