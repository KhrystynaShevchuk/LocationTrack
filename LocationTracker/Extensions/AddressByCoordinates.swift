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
    
    var currentAddress: String = ""
    
    func getAddressByCoordinates(location: CLLocation) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            self.currentAddress = ""
            
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
                self.currentAddress = self.currentAddress + streetValue
            }
            
            // City
            if let city = placeMark?.addressDictionary!["City"] as? NSString {
                let cityValue = "CITY :    \(city)\n"
                self.currentAddress = self.currentAddress + cityValue
            }
            
            // Country
            if let country = placeMark?.addressDictionary!["Country"] as? NSString {
                let countryValue = "COUNTRY :  \(country)\n"
                self.currentAddress = self.currentAddress + countryValue
            }
            
            // Country code
            if let countryCode = placeMark?.addressDictionary!["CountryCode"] as? String {
                let countryCodeValue = "COUNTRY CODE :  \(countryCode)"
                self.currentAddress = self.currentAddress + countryCodeValue
            }
        })
    }
}