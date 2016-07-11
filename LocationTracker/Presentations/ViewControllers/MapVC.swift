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
    
    //MARK: - VC life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        subscribeToNotifications()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        checkLocationAuthorizationStatus()
    }
    
    //MARK: - setup
    
    private func setup() {
        mapView.showsUserLocation = true
        setTapGestureOnPinLocation()
        
        popupView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: 100)
        view.addSubview(popupView)
        view.bringSubviewToFront(popupView)
    }
    
    private func subscribeToNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MapVC.distanceWarning(_:)), name: NOTIFICATION_TRACK_DISTANCE, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MapVC.updateUserLocation(_:)), name: NOTIFICATION_UPDATE_LOCATION, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MapVC.errorNotification(_:)), name: NOTIFICATION_ERROR, object: nil)
    }
    
    private func checkLocationAuthorizationStatus() {
        if UserLocation.sharedInstance.isAuthorized {
            mapView.showsUserLocation = true
        } else {
            UserLocation.sharedInstance.requestForAuthorization()
        }
    }
    
    //MARK: - gestures - setup
    
    private func setTapGestureOnPinLocation() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(MapVC.handleTap(_:)))
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    private func setTapGestureOnPopup() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(MapVC.tapPopupToHide(_:)))
        popupView.addGestureRecognizer(gestureRecognizer)
    }
    
    //MARK: - gesture actions
    
    func handleTap(gestureRecognizer: UILongPressGestureRecognizer) {
        let visible = (UserLocation.sharedInstance.currentLocation != nil)
        makePopupViewVisible(visible)
    }
    
    func tapPopupToHide(gestureReconizer: UILongPressGestureRecognizer) {
        _ = gestureReconizer.locationInView(popupView)
        makePopupViewVisible(false)
    }
    
    // MARK: - Notifications
    
    func updateUserLocation(notification: NSNotification) {
        let userInfo:Dictionary<String,CLLocation!> = notification.userInfo as! Dictionary<String,CLLocation!>
        let location = userInfo["location"]
        updateMapCurrentLocation(location)
    }
    
    func errorNotification(notification: NSNotification) {

        let alert = UIAlertController(title: "Error!", message: "It is impossible to get your location.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func distanceWarning(notification: NSNotification) {
        let alert = UIAlertController(title: "Warning!", message: "You are far from your start location more than 3 meters.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    private func updateMapCurrentLocation(location: CLLocation?) {
        guard let location = location else {
            return
        }
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    // MARK: - PRIVATE
    
    // set popup, popup visibility
    private func makePopupViewVisible(isViewVisible: Bool) {
        if isViewVisible {
            guard let location = UserLocation.sharedInstance.currentLocation else {
                return
            }
            UserLocation.sharedInstance.getAddressByCoordinates(location, completion: { (address) in
                
                self.popupView.addressTextView.text = address.toString
                self.yPosition = self.screenSize.height - 110
                self.popupView.setPopupOnView(self.yPosition, width: self.screenSize.width)
                self.setTapGestureOnPopup()
                self.view.bringSubviewToFront(self.popupView)
            })
            
        } else {
            yPosition = screenSize.height
            popupView.setPopupOnView(yPosition, width: screenSize.width)
            setTapGestureOnPinLocation()
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}