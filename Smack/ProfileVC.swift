//
//  ProfileVC.swift
//  Smack
//
//  Created by Brett Mayer on 9/3/17.
//  Copyright © 2017 Devslopes. All rights reserved.
//

import UIKit

//when I made this class, I check box or create XIB
class ProfileVC: UIViewController {
    
    //Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var bgView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    func setupView() {
        profileImage.image = UIImage(named: UserDataService.instance.avatarName)
        profileImage.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
        username.text = UserDataService.instance.name
        userEmail.text = UserDataService.instance.email
        
        let tap = UIGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        bgView.addGestureRecognizer(tap)
    }
    
    func handleTap(_ recognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeModalPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func logoutPressed(_ sender: Any) {
        UserDataService.instance.logoutUser()
        
        //this listens for changes on user data
        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        dismiss(animated: true, completion: nil)
    }

}
