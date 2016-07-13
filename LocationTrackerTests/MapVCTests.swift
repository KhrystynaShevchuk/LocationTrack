//
//  LocationTrackerTests.swift
//  LocationTrackerTests
//
//  Created by KhrystynaShevchuk on 7/1/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import XCTest
import UIKit
import MapKit
import CoreLocation

@testable import LocationTracker

class MapVCTests: XCTestCase {
    
    var mapView = MKMapView()
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("MapVC") 
        vc.viewDidLoad()
        
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testRegion() {
        let location = CLLocation(latitude: 49.8382600, longitude: 24.0232400)
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: center, span: span)
        
        XCTAssertNotNil(region, "Region hasn't data.")
    }
    
}
