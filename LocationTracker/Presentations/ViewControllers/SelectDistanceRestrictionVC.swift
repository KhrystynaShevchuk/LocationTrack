//
//  SelectDistanceRestrictionVC.swift
//  LocationTracker
//
//  Created by KhrystynaShevchuk on 7/12/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import Foundation
import UIKit

class SelectDistanceRestrictionVC: UIViewController {
    
    struct defaultsKeys {
        static let keyForDistance = "distanceRestriction"
    }
    
    var currentValue = Int()
    private var lastDistanceRestrictValue = [Double : defaultsKeys]()
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var label_0: UILabel!
    @IBOutlet weak var label_500: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        // Store
        defaults.setObject(currentValue, forKey: "distanceRestriction")
        
        // Receive
        UserLocation.sharedInstance.distanceRestriction = defaults.doubleForKey("distanceRestriction")

    }
    
    @IBAction func distanceSelecterSlider(slider: UISlider) {
        currentValue = lroundf(slider.value)
    }
}
