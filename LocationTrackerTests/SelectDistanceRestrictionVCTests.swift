//
//  SelectDistanceRestrictionVCTests.swift
//  LocationTracker
//
//  Created by KhrystynaShevchuk on 7/13/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import XCTest
@testable import LocationTracker

class SelectDistanceRestrictionVCTests: XCTestCase {
    
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("SelectDistanceRestrictionVC")
        vc.viewDidLoad()
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testReceivedValue() {
        struct testDefaultsKeys {
            static let keyForDistance = "key"
        }
        
        let received = 15
        NSUserDefaults.standardUserDefaults().setInteger(received, forKey: "key")
        let distanceRestriction = Int(NSUserDefaults.standardUserDefaults().integerForKey("key"))
        
        XCTAssertEqual(distanceRestriction, received, "Some problems with receiving default values.")
    }
}