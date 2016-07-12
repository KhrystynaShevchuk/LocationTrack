//
//  ShowAddressCustomView.swift
//  LocationTracker
//
//  Created by KhrystynaShevchuk on 7/4/16.
//  Copyright © 2016 KhrystynaShevchuk. All rights reserved.
//

import UIKit

@IBDesignable
class ShowAddressCustomView: UIView {
    
    // Root view - needs in case it loads(creates) from code
    private var view: UIView!

    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    
    // For using CustomView in code
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        xibSetup()
    }
    
    // For using CustomView in IB
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        xibSetup()
    }
    
    private func xibSetup() {
        view = loadViewFromNib("ShowAddressCustomView")
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
        
        addressTextView.clipsToBounds = true
		iconImageView.image = UIImage(named: "icon")
        
    }
    
    private func loadViewFromNib(nibName: String) -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }
}