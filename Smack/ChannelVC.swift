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
    @IBOutlet weak var userImage: CircleImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        setupUserInfo()
    }
    
//    override func viewDidAppear(_ animated: Bool) {  //What is the difference betweem this and using notifications?
//        super.viewDidAppear(true)
//        
//        print("view loaded")
//        print(AuthService.instance.isLoggedIn)
//        userDataDidChange()
//
//    }

    @IBAction func loginBtnPressed(_ sender: Any) {
        
        if AuthService.instance.isLoggedIn {
            let profile = ProfileVC()
            profile.modalPresentationStyle = .custom
            present(profile, animated: true, completion: nil)
            
        } else {
         performSegue(withIdentifier: TO_LOGIN, sender: nil)
        }
        
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {}
    
    func userDataDidChange(_ notif: Notification) {
    //func userDataDidChange() {
        setupUserInfo()
    }
    
    func setupUserInfo() {
        
        if AuthService.instance.isLoggedIn {
            print("notification worked")
            loginBtn.setTitle(UserDataService.instance.name, for: .normal)
            userImage.image = UIImage(named: UserDataService.instance.avatarName)
            print("What im looking for: \(UserDataService.instance.avatarName)")
            let avColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
            print("avatarcolor from func: \(avColor)")
            userImage.backgroundColor = avColor
            
        } else {
            loginBtn.setTitle("Login", for: .normal)
            userImage.image = UIImage(named: "menuProfileIcon")
            userImage.backgroundColor = UIColor.clear
        }

    }



}
