//
//  File.swift
//  LocationTracker
//
//  Created by IOS developer on 7/7/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import Foundation

class Address {
    
    var street: String?
    var city: String?
    var country: String?
    var countryCode: String?
   
    init(dictionary: [NSObject : AnyObject]) {
        self.street = dictionary["Street"] as? String
        self.city = dictionary["City"] as? String
        self.country = dictionary["Country"] as? String
        self.countryCode = dictionary["CountryCode"] as? String
    }
    
    var toString: String {
        var currentAddress = ""
        if street != nil && city != nil {
            currentAddress += "STREET :  \(street ?? "")\n"
            currentAddress += "CITY :    \(city ?? "")\n"
            currentAddress += "COUNTRY :    \(country ?? "")\n"
            currentAddress += "COUNTRY CODE :  \(countryCode ?? "")\n"
            currentAddress += UserLocation.sharedInstance.coordinates
            currentAddress += "Distance restriction =  \(UserLocation.sharedInstance.distanceRestriction) m"
        } else {
            currentAddress += "It is impossible to detect address\nby selected location."
        }
        return currentAddress
    }
}