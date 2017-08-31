//
//  CreateAccountVC.swift
//  Smack
//
//  Created by Brett Mayer on 8/31/17.
//  Copyright © 2017 Devslopes. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func closePressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND, sender: nil)
    }


}
