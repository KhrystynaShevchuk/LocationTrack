//
//  ShowAddressCustomView.swift
//  LocationTracker
//
//  Created by KhrystynaShevchuk on 7/4/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import UIKit

class ShowAddressCustomView: UIView {

    @IBOutlet weak var addressTextView: UITextView!
    
    //var completion: ((text: String) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        addressTextView.text = completion?
       // completion?(text: addressTextView.text)
    }
}