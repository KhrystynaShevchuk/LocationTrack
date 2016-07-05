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
    
    // MARK: - OUTLETS

    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - PROPERTIES
    
    var popupView = ShowAddressCustomView()
    let screenSize = UIScreen.mainScreen().bounds
    var yPosition : CGFloat = 0
    let locationManager = CLLocationManager()
    var currentAddress: String = ""
    
    // MARK: - LIFI CIRCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        setTapGestureOnPinLocation()
        setupPopview()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        setupLocation()
        
        self.view.addSubview(popupView)
        self.popupView.frame = CGRect(x: 0, y: screenSize.height, width: self.screenSize.width, height: 100)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        mapView.showsUserLocation = true
        
        checkLocationAuthorizationStatus()
    }
    
    // MARK: - PUBLIC
    
    func setupLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.startUpdatingLocation()
        locationManager.requestAlwaysAuthorization()
    }
    
    func setTapGestureOnPinLocation() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(MapVC.handleTap(_:)))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    func setTapGestureOnPopup() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(MapVC.tapPopupToHide(_:)))
        gestureRecognizer.delegate = self
        popupView.addGestureRecognizer(gestureRecognizer)
    }
    
    func handleTap(gestureReconizer: UILongPressGestureRecognizer) {
        _ = gestureReconizer.locationInView(mapView)
        if locationManager.location != nil {
            makePopupViewVisible(true)
        } else {
            makePopupViewVisible(false)
        }
    }
    
    func tapPopupToHide(gestureReconizer: UILongPressGestureRecognizer) {
        _ = gestureReconizer.locationInView(popupView)
        makePopupViewVisible(false)
    }
    
    func setupPopview() {
        if let views = NSBundle.mainBundle().loadNibNamed("ShowAddressCustomView", owner: nil, options: nil)
        {
            popupView = views.last as! ShowAddressCustomView
            
            popupView.addressTextView.layer.cornerRadius = 8.0
            popupView.addressTextView.clipsToBounds = true
            popupView.addressTextView.layer.borderColor = UIColor.greenColor().CGColor
            popupView.addressTextView.layer.borderWidth = 2
            
            self.view.addSubview(popupView)
        }
    }
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    // MARK: - PRIVATE
    
    // set popup, popup visibility
    private func makePopupViewVisible(isViewVisible: Bool) {
        if isViewVisible == true {
            self.popupView.addressTextView.text = self.currentAddress
            yPosition = screenSize.height - 110
            setPopupOnView(yPosition)
            setTapGestureOnPopup()
            
        } else {
            yPosition = screenSize.height
            setPopupOnView(yPosition)
            setTapGestureOnPinLocation()
        }
    }
    
    private func setPopupOnView(yPosition: CGFloat) {
        UIView.animateWithDuration(0.7, delay: 1.0, options: .CurveEaseOut, animations: {
            self.popupView.frame = CGRect(x: 0, y: yPosition, width: self.screenSize.width, height: 100)
            }) { finished in
        }
    }
    
    // get address by coordinates
    private func getAddressByCoordinates(location: CLLocation) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            self.currentAddress = ""
            
            // Place details
            var placeMark: CLPlacemark?
            placeMark = placemarks?[0]
            
            // Address dictionary
            if placeMark != nil {
                print(placeMark!.addressDictionary)
            }
            
            // Street address
            if let street = placeMark?.addressDictionary!["Thoroughfare"] as? NSString {
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

extension MapVC: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locationManager.location!
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
        let region = MKCoordinateRegion(center: center, span: span)
        
        mapView.setRegion(region, animated: true)
        getAddressByCoordinates(location)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("didFailWithError: \(error.description)")
        let errorAlert = UIAlertController(title: "Error", message: "Failed to Get Your Location", preferredStyle: .Alert)
        presentViewController(errorAlert, animated: true, completion: nil)
    }
}

extension MapVC: MKMapViewDelegate {

}

extension MapVC: UIGestureRecognizerDelegate {
}