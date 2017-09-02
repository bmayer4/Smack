//
//  RoundedButton.swift
//  Smack
//
//  Created by Brett Mayer on 9/1/17.
//  Copyright © 2017 Devslopes. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 25.0 {
        didSet {
            self.setupView()
        }
    }
   
    //If I comment this out (with prepareForIB), still works in IB and when I run it. Must be didSet doing all the work...
    //But that is only when cornerradius has been set in storyboard, use this method anyway
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupView()
    }

    //if I comment this out you can still see the changes in storyboard...?
    //I read online when you use didSet you can avoid using prepareForInterfaceBuilder, even awakefromnib
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        self.setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = cornerRadius
    }
    
    
    
    //this is what I like the best
    //**USE THIS WAY WITHOUT @IBInspectable, but with @IBDesignable
//        override func awakeFromNib() {
//            super.awakeFromNib()
//    
//            self.setupView()
//        }
//
//        override func prepareForInterfaceBuilder() {
//            super.prepareForInterfaceBuilder()
//    
//            self.setupView()
//        }
//    
//        func setupView() {
//            self.layer.cornerRadius = 5
//        }

    

}
