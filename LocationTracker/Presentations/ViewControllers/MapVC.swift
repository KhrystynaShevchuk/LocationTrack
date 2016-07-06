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
    
    //    var addressByCoordinates = AddressByCoordinates()
    var popupView: ShowAddressCustomView!
    let screenSize = UIScreen.mainScreen().bounds
    var yPosition : CGFloat = 0
    
    
    //MARK: vc life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        setupUserLocation()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        checkLocationAuthorizationStatus()
    }
    
    
    //MARK : setup
    
    private func setup() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        setTapGestureOnPinLocation()
        
        popupView = ShowAddressCustomView()
        popupView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: 100)
        self.view.addSubview(popupView)
        self.view.bringSubviewToFront(popupView)
    }
    
    private func setupUserLocation() {
        //        UserLocation.sharedInstance.locationDidUpdateHandler = { location in
        //            print("location = \(location)")
        //            self.updateMapCurrentLocation(location)
        //        }
        UserLocation.sharedInstance.locationDidUpdateHandler = updateMapCurrentLocation
    }
    
    private func checkLocationAuthorizationStatus() {
        if UserLocation.sharedInstance.isAuthorized {
            mapView.showsUserLocation = true
        } else {
            UserLocation.sharedInstance.requestForAuthorization()
        }
    }
    
    
    //MARK: gestures - setup
    
    private func setTapGestureOnPinLocation() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(MapVC.handleTap(_:)))
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    private func setTapGestureOnPopup() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(MapVC.tapPopupToHide(_:)))
        popupView.addGestureRecognizer(gestureRecognizer)
    }
    
    
    //MARK: gesture actions
    
    func handleTap(gestureRecognizer: UILongPressGestureRecognizer) {
//        _ = gestureRecognizer.locationInView(mapView)
        if UserLocation.sharedInstance.currentLocation != nil {
            makePopupViewVisible(true)
        } else {
            makePopupViewVisible(false)
        }
        //        let visible = UserLocation.sharedInstance.currentLocation != nil
        //        makePopupViewVisible(visible)
    }
    
    func tapPopupToHide(gestureReconizer: UILongPressGestureRecognizer) {
        _ = gestureReconizer.locationInView(popupView)
        makePopupViewVisible(false)
    }
    
    
    // MARK: - PRIVATE
    
    // set popup, popup visibility
    private func makePopupViewVisible(isViewVisible: Bool) {
        if isViewVisible {
            guard let location = UserLocation.sharedInstance.currentLocation else {
                //???
                return
            }
            AddressByCoordinates.sharedInstance.getAddressByCoordinates(location, completion: { (address) in
                
                self.popupView.addressTextView.text = address
                self.yPosition = self.screenSize.height - 110
                self.popupView.setPopupOnView(self.yPosition, width: self.screenSize.width)
                self.setTapGestureOnPopup()
                self.view.bringSubviewToFront(self.popupView)
            })
//            //            self.popupView.addressTextView.text = addressByCoordinates.currentAddress
//            yPosition = screenSize.height - 110
//            //            yPosition = screenSize.height - popupView.frame.height
//            popupView.setPopupOnView(yPosition, width: screenSize.width)
//            setTapGestureOnPopup()
        } else {
            yPosition = screenSize.height
            popupView.setPopupOnView(yPosition, width: screenSize.width)
            setTapGestureOnPinLocation()
        }
    }
    
    private func updateMapCurrentLocation(location: CLLocation?) {
        if let location = location {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
            let region = MKCoordinateRegion(center: center, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    //    func getAddressBy(location: CLLocation) {
    //        let location = UserLocation.sharedInstance.currentLocation
    //        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    //        let span = MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
    //        let region = MKCoordinateRegion(center: center, span: span)
    //        mapView.setRegion(region, animated: true)
    //
    //        addressByCoordinates.getAddressByCoordinates(location)
    //    }
}

extension MapVC: MKMapViewDelegate {
    
}