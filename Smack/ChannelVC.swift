//
//  ChannelVC.swift
//  Smack
//
//  Created by Brett Mayer on 8/29/17.
//  Copyright © 2017 Devslopes. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController {

    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
        
    }

    @IBAction func loginBtnPressed(_ sender: Any) {
        
        performSegue(withIdentifier: TO_LOGIN, sender: nil)
        
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {}


}
