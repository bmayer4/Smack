//
//  LoginVC.swift
//  Smack
//
//  Created by Brett Mayer on 8/31/17.
//  Copyright © 2017 Devslopes. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    //Outlets
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        
        spinner.isHidden = false
        spinner.startAnimating()
        
        guard let email = usernameTxt.text, email != "" else { return }  //outlet should be email
        
        guard let password = passwordTxt.text, password != "" else { return }

        AuthService.instance.loginUser(email: email, password: password) { (success) in
            
            if success {
                
                AuthService.instance.findUserByEmail(completion: { (success) in
                    if success {
                    self.spinner.isHidden = true
                    self.spinner.stopAnimating()
                    
                    NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                    self.dismiss(animated: true, completion: nil)

                    }
                })
                
            }
            
        }
    }
    

    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func createAcctPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_CREATE_ACCOUNT, sender: nil)
    }
    
    func setupView() {
        
        spinner.isHidden = true
        
        
        usernameTxt.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSForegroundColorAttributeName: smackPurplePlaceholder])

        passwordTxt.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSForegroundColorAttributeName: smackPurplePlaceholder])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CreateAccountVC.handleTap))
        view.addGestureRecognizer(tap)

        
    }
    
    func handleTap() {
        view.endEditing(true)
    }

}
