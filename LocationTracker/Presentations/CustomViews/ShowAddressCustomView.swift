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
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addressTextView.layer.cornerRadius = 8.0
        addressTextView.clipsToBounds = true
        addressTextView.layer.borderColor = UIColor.greenColor().CGColor
        addressTextView.layer.borderWidth = 2
    }
    
    func setPopupOnView(yPosition: CGFloat, width: CGFloat) {
        UIView.animateWithDuration(0.7, delay: 1.0, options: .CurveEaseOut, animations: {
            self.addressTextView.frame = CGRect(x: 0, y: yPosition, width: width, height: 100)
        }) { finished in
        }
    }
}