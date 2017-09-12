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
        tableView.dataSource = self
 
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
        
        //****This is a listener and set up here which gets called before we even visit this VC, faster than viewDidAppear!
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        
        SocketService.instance.getChannel { (success) in
            if success {
                print("got socket channel!")
                self.tableView.reloadData()
            }
        }
        
        //we are listening for new messages here also (ChatVC is), but we're interested in messages that come from channels
        //that we do not have currently selected
        SocketService.instance.getChatMessage { (newMessage) in
            if newMessage.channelId != MessageService.instance.selectedChannel?.id && AuthService.instance.isLoggedIn {
                
                //now we have a channel that has some unread message inside of it
                MessageService.instance.unreadChannels.append(newMessage.channelId) //will do work w this in ChannelCell
                self.tableView.reloadData()
            }
        }
        
    }
    
    //adding this in in case this view isn't instantiated whem ChatVC calls the notification
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        setupUserInfo()
    }
    
    @IBAction func addChannelPressed(_ sender: Any) {
        
        if AuthService.instance.isLoggedIn {
            let addChannelVC = AddChannelVC()
            addChannelVC.modalPresentationStyle = .custom
            present(addChannelVC, animated: true, completion: nil)
        }
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
            tableView.reloadData() //I added this, teacher wanted to add another notif "NOTIF_CHANNELS_LOADED"
            print("tableview reloaded using my way")
        } else {
            loginBtn.setTitle("Login", for: .normal)
            userImage.image = UIImage(named: "menuProfileIcon")
            userImage.backgroundColor = UIColor.clear
            tableView.reloadData()  //since we logged out and channels array will be empty, we want to reload and clear it
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.channels.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "channelCell", for: indexPath) as? ChannelCell {
            let channel = MessageService.instance.channels[indexPath.row]
            cell.configureCell(channel: channel)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = MessageService.instance.channels[indexPath.row]
        MessageService.instance.selectedChannel = channel
        
        //When we click on a row, we are going to see if there are some unread messages, if there are, we will filter out the one we just clicked on, then we reload it, which will reload that row and now its not an unread channel so it wont be big, then we reselect it so we have our set selected fade on it
        if MessageService.instance.unreadChannels.count > 0 {
            MessageService.instance.unreadChannels = MessageService.instance.unreadChannels.filter{$0 != channel.id}
        }
        
        let index = IndexPath(row: indexPath.row, section: 0)
        tableView.reloadRows(at: [index], with: .none)
        //now reselect the row, won't do a double select or anything
        //doing ths because when we reload the row above for some reason it doesn't make cell selected for ChannelCell to know
        tableView.selectRow(at: index, animated: false, scrollPosition: .none)
        
        NotificationCenter.default.post(name: NOTIF_CHANNELS_SELECTED, object: nil)
        self.revealViewController().revealToggle(animated: true) //slides back and forth 
    }


}
