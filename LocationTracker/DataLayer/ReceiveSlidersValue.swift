//
//  ReceiveSlidersValue.swift
//  LocationTracker
//
//  Created by KhrystynaShevchuk on 7/13/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import Foundation
import UIKit

class ReceiveRestrictDistanceFromSlider {
    
    static var sharedInstance = ReceiveRestrictDistanceFromSlider()
    
    struct defaultsKeys {
        static let keyForDistance = "distanceRestriction"
    }
    
    var currentValue = Int()
    var receivedValue = NSUserDefaults.standardUserDefaults().integerForKey(defaultsKeys.keyForDistance)
    

    func setSlidersPoint(slider: UISlider) {
        
        // slider stops at discrete point
        currentValue = lroundf(slider.value)
    }
    
    func tappedSaveButton(sender: UIBarButtonItem) {
        
        // store slider's value
        NSUserDefaults.standardUserDefaults().setInteger(currentValue, forKey: defaultsKeys.keyForDistance)
        receivedValue = NSUserDefaults.standardUserDefaults().integerForKey(defaultsKeys.keyForDistance)
        UserLocation.sharedInstance.distanceRestriction = receivedValue
    }
}