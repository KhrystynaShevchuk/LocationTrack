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
    let startYPosition : CGFloat = UIScreen.mainScreen().bounds.height - 55
    let newYPosition: CGFloat = 2/5 * UIScreen.mainScreen().bounds.height
    
    //MARK: - VC life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPopup()
        subscribeToNotifications()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        checkLocationAuthorizationStatus()
    }
    
    //MARK: - setup
    
    private func setupPopup() {
        view.addSubview(popupView)
        view.bringSubviewToFront(popupView)
        popupView.frame = CGRect(x: 0, y: startYPosition, width: self.screenSize.width, height: self.screenSize.height)
        
        self.popupView.addressTextView.text = "\n\tNo location - no address!"

        setTapGestureOnPopup()
        setSwipeUpGestureOnPopup()
        setSwipeDownGestureOnPopup()
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
    
    private func setSwipeUpGestureOnPopup() {
        let gestureRecognizer = UISwipeGestureRecognizer(target: self, action:#selector(MapVC.handleTap(_:)))
        gestureRecognizer.direction = .Up
        popupView.addGestureRecognizer(gestureRecognizer)
    }
    
    private func setSwipeDownGestureOnPopup() {
        let gestureRecognizer = UISwipeGestureRecognizer(target: self, action:#selector(MapVC.handleTap(_:)))
        gestureRecognizer.direction = .Down
        popupView.addGestureRecognizer(gestureRecognizer)
    }
    
    private func setTapGestureOnPopup() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(MapVC.handleTap(_:)))
        popupView.addGestureRecognizer(gestureRecognizer)
    }
    
    //MARK: - gesture actions
    
    func handleTap(gestureRecognizer: UILongPressGestureRecognizer) {
        if popupView.frame.origin.y == startYPosition {
            makePopupViewVisible(visible: true)
        } else {
            makePopupViewVisible(visible: false)
        }
    }
    
    // MARK: - Notifications
    
    func updateUserLocation(notification: NSNotification) {
        let userInfo:Dictionary<String,CLLocation!> = notification.userInfo as! Dictionary<String,CLLocation!>
        let location = userInfo["location"]
       
        if let region = updateMapCurrentLocation(location) {
            mapView.setRegion(region, animated: true)
        }
        
        getAddressOFUserLocation()
    }
    
    func errorNotification(notification: NSNotification) {

        let alert = UIAlertController(title: "Error!", message: "It is impossible to get your location.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func distanceWarning(notification: NSNotification) {
        let alert = UIAlertController(title: "Warning!", message: "You are far from your start location more than \(UserLocation.sharedInstance.distanceRestriction) meters.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    private func updateMapCurrentLocation(location: CLLocation?) -> MKCoordinateRegion? {
        guard let location = location else {
            return nil
        }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: center, span: span)
        
        return region
    }
    
    // MARK: - PRIVATE
    
    // set popup, popup visibility
    private func makePopupViewVisible(visible isViewVisible: Bool) {
        if isViewVisible {
            animatePopup(yPosition: newYPosition)
            
        } else {
            animatePopup(yPosition: startYPosition)
        }
    }
    
    private func animatePopup(yPosition yPosition: CGFloat) {
        UIView.animateWithDuration(0.8, delay: 0.5, options: .CurveEaseOut, animations: {
            self.popupView.frame = CGRect(x: 0, y: yPosition, width: self.screenSize.width, height: self.screenSize.height)
        }) { finished in
            
        }
    }
    
    private func getAddressOFUserLocation() {
        guard let location = UserLocation.sharedInstance.currentLocation else {
            return
        }
        UserLocation.sharedInstance.getAddressByCoordinates(location, completion: { (address) in
            self.popupView.addressTextView.text = address.toString
        })
    }
        
    @IBAction func selectDistanceRestriction(sender: UIBarButtonItem) {
        performSegueWithIdentifier("selectDistanceSegue", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "selectDistanceSegue" {
            _ = segue.destinationViewController as! SelectDistanceRestrictionVC
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}