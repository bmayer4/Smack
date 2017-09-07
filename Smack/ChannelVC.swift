//
//  ChannelVC.swift
//  Smack
//
//  Created by Brett Mayer on 8/29/17.
//  Copyright © 2017 Devslopes. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var userImage: CircleImage!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.delegate = self
 
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
        
        //****This is a listener and set up here which gets called before we even visit this VC, faster than viewDidAppear!
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        
    }
    
    //adding this in in case this view isn't instantiated whem ChatVC calls the notification
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        setupUserInfo()
    }
    

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

        setupUserInfo()
    }
    
    func setupUserInfo() {
        
        if AuthService.instance.isLoggedIn {
            print("notification worked from ChannelVC")
            loginBtn.setTitle(UserDataService.instance.name, for: .normal)
            userImage.image = UIImage(named: UserDataService.instance.avatarName)
            let avColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
            userImage.backgroundColor = avColor
            
        } else {
            loginBtn.setTitle("Login", for: .normal)
            userImage.image = UIImage(named: "menuProfileIcon")
            userImage.backgroundColor = UIColor.clear
        }

    }
    
    //required
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.channels.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "channelCell", for: indexPath) as? ChannelCell {
            let chan = MessageService.instance.channels[indexPath.row]
            cell.configureCell(channel: chan)
            return cell
        } else {
            return ChannelCell()
        }
    }


}
