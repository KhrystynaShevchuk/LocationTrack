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
    
    var userLocation = UserLocation()
    var addressByCoordinates = AddressByCoordinates()
    var popupView = ShowAddressCustomView()
    let screenSize = UIScreen.mainScreen().bounds
    var yPosition : CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        userLocation.setupLocation()
        mapView.showsUserLocation = true
        setTapGestureOnPinLocation()
        
        
        self.view.addSubview(popupView)
        popupView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: 100)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        mapView.showsUserLocation = true
        
        checkLocationAuthorizationStatus()
    }
    func handleTap(gestureRecognizer: UILongPressGestureRecognizer) {
        _ = gestureRecognizer.locationInView(mapView)
        if
            userLocation.locationManager.location != nil {
            makePopupViewVisible(true, mapView: mapView)
        } else {
            makePopupViewVisible(false, mapView: mapView)
        }
    }
    
    func tapPopupToHide(gestureReconizer: UILongPressGestureRecognizer) {
        _ = gestureReconizer.locationInView(popupView)
        makePopupViewVisible(false, mapView: mapView)
    }
    
    func setTapGestureOnPinLocation() {
        let gestureRecognizer = UITapGestureRecognizer(target: userLocation.locationManager, action:#selector(MapVC.handleTap(_:)))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    func setTapGestureOnPopup() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(MapVC.tapPopupToHide(_:)))
        gestureRecognizer.delegate = self
        popupView.addGestureRecognizer(gestureRecognizer)
    }
    
        func checkLocationAuthorizationStatus() {
            if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
                mapView.showsUserLocation = true
            } else {
                userLocation.locationManager.requestAlwaysAuthorization()
            }
        }
    
    // MARK: - PRIVATE
    
    // set popup, popup visibility
    private func makePopupViewVisible(isViewVisible: Bool, mapView: MKMapView) {
        if isViewVisible == true {
            self.popupView.addressTextView.text = addressByCoordinates.currentAddress
            yPosition = screenSize.height - 110
            popupView.setPopupOnView(yPosition, width: screenSize.width)
            setTapGestureOnPopup()
            
        } else {
            yPosition = screenSize.height
            popupView.setPopupOnView(yPosition, width: screenSize.width)
            setTapGestureOnPinLocation()
        }
    }
    
    func getAddressBy(location: CLLocation) {
        let location = userLocation.locationManager.location!
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
        
        addressByCoordinates.getAddressByCoordinates(location)
    }
}

extension MapVC: MKMapViewDelegate {
    
}

extension MapVC: UIGestureRecognizerDelegate {
    
}