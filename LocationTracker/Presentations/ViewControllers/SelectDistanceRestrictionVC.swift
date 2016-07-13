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
    

    
//    var currentValue = Int()
    
    @IBOutlet weak var sliderSlider: UISlider!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var minValueLabel: UILabel!
    @IBOutlet weak var maxValueLabel: UILabel!
    @IBOutlet weak var resultsTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sliderSlider.value = Float(ReceiveRestrictDistanceFromSlider.sharedInstance.receivedValue)
        resultsTextField.text = "\(ReceiveRestrictDistanceFromSlider.sharedInstance.receivedValue) m"
        
    }
    
    @IBAction func selectedDistanceSlider(slider: UISlider) {
        ReceiveRestrictDistanceFromSlider.sharedInstance.setSlidersPoint(slider)
        resultsTextField.text = "\(ReceiveRestrictDistanceFromSlider.sharedInstance.currentValue) m"
    }
    
    @IBAction func saveButton(sender: UIBarButtonItem) {
        ReceiveRestrictDistanceFromSlider.sharedInstance.tappedSaveButton(sender)
        
    }
}
