//
//  ViewController.swift
//  LocationTracker
//
//  Created by KhrystynaShevchuk on 7/1/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var popupView = ShowAddressCustomView()
    let screenSize = UIScreen.mainScreen().bounds
    var yPosition : CGFloat = 0
    
    let locationManager = CLLocationManager()
    var currentAddress: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if let views = NSBundle.mainBundle().loadNibNamed("ShowAddressCustomView", owner: nil, options: nil)
        {
            popupView = views.last as! ShowAddressCustomView
            
            popupView.addressTextView.layer.cornerRadius = 8.0
            popupView.addressTextView.clipsToBounds = true
            popupView.addressTextView.layer.borderColor = UIColor.greenColor().CGColor
            popupView.addressTextView.layer.borderWidth = 2
            
            self.view.addSubview(popupView)
        }

        // setup mapView
        
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        // setup location
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // gesture recognizer
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(MapVC.handleTap(_:)))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
        
       //popupView.frame = CGRectMake(0, 0, 100, 100)
        
        self.view.addSubview(popupView)
    
        self.popupView.frame = CGRect(x: 0, y: screenSize.height, width: self.screenSize.width, height: 100)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        checkLocationAuthorizationStatus()
    }
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func handleTap(gestureReconizer: UILongPressGestureRecognizer) {
        _ = gestureReconizer.locationInView(mapView)
        makePopupViewVisible(true)
    }

    
    private func makePopupViewVisible(isViewVisible: Bool) {
        if isViewVisible == true {
            self.popupView.addressTextView.text = self.currentAddress
            
            yPosition = screenSize.height - 110
            setShowAddressCustomView(yPosition)
            
        } else {
            yPosition = screenSize.height
            setShowAddressCustomView(yPosition)
        }
    }
    
    private func setShowAddressCustomView(yPosition: CGFloat) {
        UIView.animateWithDuration(0.7, delay: 1.0, options: .CurveEaseOut, animations: {
            self.popupView.frame = CGRect(x: 0, y: yPosition, width: self.screenSize.width, height: 100)
            }) { finished in
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension MapVC: UIGestureRecognizerDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        let location = locationManager.location!
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
        let region = MKCoordinateRegion(center: center, span: span)
        
        mapView.setRegion(region, animated: true)
        
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            self.currentAddress = ""
                        
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            // Address dictionary
            print(placeMark.addressDictionary)
            
            // Street address
            if let street = placeMark.addressDictionary!["Thoroughfare"] as? NSString {
                let streetValue = "STREET :  \(street)\n"
                self.currentAddress = self.currentAddress + streetValue
            }
            
            // City
            if let city = placeMark.addressDictionary!["City"] as? NSString {
                let cityValue = "CITY :    \(city)\n"
                self.currentAddress = self.currentAddress + cityValue
            }
            
            
            // Country
            if let country = placeMark.addressDictionary!["Country"] as? NSString {
                let countryValue = "COUNTRY :  \(country)\n"
                self.currentAddress = self.currentAddress + countryValue
            }
            
            // Country code
            if let countryCode = placeMark.addressDictionary!["CountryCode"] as? String {
                let countryCodeValue = "COUNTRY CODE :  \(countryCode)"
                self.currentAddress = self.currentAddress + countryCodeValue
            }
        })
    }
}
