//
//  CreateAccountVC.swift
//  Smack
//
//  Created by Brett Mayer on 8/31/17.
//  Copyright © 2017 Devslopes. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {

    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var userImg: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func closePressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND, sender: nil)
    }

    @IBAction func createAccountPressed(_ sender: Any) {
        guard let email = emailTxt.text, emailTxt.text != "" else {
            return
        }
        guard let password = passwordTxt.text, passwordTxt.text != "" else {
            return
        }
        
        AuthService.instance.registerUser(email: email, password: password) { (success) in
            if success {
                print("Registered user!")
            } else {
                
            }

        }
        
    }

    @IBAction func pickAvatarPressed(_ sender: Any) {
    }
    
    @IBAction func pickBGColorPressed(_ sender: Any) {
    }
    
}
