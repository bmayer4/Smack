//
//  GradientView.swift
//  Smack
//
//  Created by Brett Mayer on 8/30/17.
//  Copyright © 2017 Devslopes. All rights reserved.
//

import UIKit

@IBDesignable    //WHY was prepareforinterfacebuilder not called..it still worked..? It def works for some things
class GradientView: UIView {

    @IBInspectable var topColor: UIColor = #colorLiteral(red: 0.2901960784, green: 0.3019607843, blue: 0.8470588235, alpha: 1) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var bottomColor: UIColor = #colorLiteral(red: 0.1725490196, green: 0.831372549, blue: 0.8470588235, alpha: 1) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    //when you call setNeedsLayout, this below is called
    override func layoutSubviews() {
        
        let gradientLayer = CAGradientLayer()
        
        //need colors, start/end point (coordinate system (0,0) top left and (1,1) bottom right, and size
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = self.bounds
        
        self.layer.insertSublayer(gradientLayer, at: 0)
        
    }


}
