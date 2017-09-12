//
//  ChatVC.swift
//  Smack
//
//  Created by Brett Mayer on 8/29/17.
//  Copyright © 2017 Devslopes. All rights reserved.
//

import UIKit

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    //Outlets
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var channelNameLbl: UILabel!
    @IBOutlet weak var messageTextBox: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var typingUsersLabel: UILabel!
    
    //Variables
    var isTyping = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        sendButton.isHidden = true
        
        //before this, I set messageBody in storyboard to 0 lines (no limit)
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        
        view.bindToKeyboard()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatVC.handleTap))
        view.addGestureRecognizer(tap)
        
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil) 
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelSelected(_:)), name: NOTIF_CHANNELS_SELECTED, object: nil)
        
        SocketService.instance.getChatMessage { (newMessage) in
            
            //doing this here so we can access the new message regardless of whether it was made in a channel we have selected
            //we are also listening in channelVC
            if newMessage.channelId == MessageService.instance.selectedChannel?.id && AuthService.instance.isLoggedIn {
                MessageService.instance.messages.append(newMessage)
                self.tableView.reloadData()
                
                if MessageService.instance.messages.count > 0 {
                    let endIndex = IndexPath(item: MessageService.instance.messages.count - 1, section: 0)
                    self.tableView.scrollToRow(at: endIndex, at: .bottom, animated: false)
                }
            }
        }
        
        
//        SocketService.instance.getChatMessage { (success) in
//            if success {
//                self.tableView.reloadData()
//                
//                //when message is added to table, it doesn't scroll down to latest one. Fix this here:
//                if MessageService.instance.messages.count > 0 {
//                    let endIndex = IndexPath(item: MessageService.instance.messages.count - 1, section: 0)
//                    self.tableView.scrollToRow(at: endIndex, at: .bottom, animated: false)
//                }
//            }
//        }
        
        SocketService.instance.getTypingUsers { (typingUsers) in
            //now we have a dictionary of users, where key is username and value is channel
            guard let channelId = MessageService.instance.selectedChannel?.id else { return }
            var names = ""  //will hold names of who is typing
            var numberOfTypers = 0
            
            for (typingUser, channel) in typingUsers {
                if typingUser != UserDataService.instance.name && channel == channelId {
                    if names == "" {  //either first person in dictionary loop, or if there is only one person typing
                        names = typingUser
                    } else {
                        names = "\(names), \(typingUser)"
                    }
                    numberOfTypers += 1
                }
            }
            
            //when everyone stops typing, the dictionary is still returned to us and this function is still called
            if numberOfTypers > 0 && AuthService.instance.isLoggedIn == true {
                var verb = "is" //assume one person is typing
                if numberOfTypers > 1 {
                    verb = "are"
                }
                
                self.typingUsersLabel.text = "\(names)\(verb) typing a message"
            } else {
                self.typingUsersLabel.text = ""
            }
        }
        
        
        if AuthService.instance.isLoggedIn {
            print("user is logged in")
            AuthService.instance.findUserByEmail(completion: { (success) in
                if success {
                    NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                }
            })
        }
    }
    
    

    func userDataDidChange(_ notif: Notification) {
        if AuthService.instance.isLoggedIn {
            onLoginGetMessages()
        } else {
            channelNameLbl.text = "Please Log in"
            tableView.reloadData()
        }
    }
    
    func channelSelected(_ notif: Notification) {
        updateWithChannel()
    }
    
    func handleTap() {
        view.endEditing(true)
    }
    
    func updateWithChannel() {
        let channelName = MessageService.instance.selectedChannel?.channelTitle ?? ""
        channelNameLbl.text = "#\(channelName)"
        getMessages()
    }
    
    //**editing changes is the event type, called after an editing occurs
    @IBAction func messageBoxEditing(_ sender: Any) {
        
        guard let channelId = MessageService.instance.selectedChannel?.id else { return }
        
//        if messageTextBox.text == "" {
//            isTyping = false
//            sendButton.isHidden = true
//        } else {
//            if isTyping == false {
//                sendButton.isHidden = false
//            }
//            isTyping = true
//        }
        
        //my way, no var
        if messageTextBox.text != "" {
            sendButton.isHidden = false
            SocketService.instance.socket.emit("startType", UserDataService.instance.name, channelId)
        } else {
            sendButton.isHidden = true
            SocketService.instance.socket.emit("stopType", UserDataService.instance.name, channelId)

        }

    }
    
    
    @IBAction func sendMessagePressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn {
            guard let channelId = MessageService.instance.selectedChannel?.id else { return }
            guard let message = messageTextBox.text else { return }
            
            SocketService.instance.addMessage(messageBody: message, userId: UserDataService.instance.id, channelId: channelId, completion: { (success) in
                self.messageTextBox.text = ""
                self.messageTextBox.resignFirstResponder()
                SocketService.instance.socket.emit("stopType", UserDataService.instance.name, channelId)
            })
            
        }
    }
    
    //gets called when app loads, or when user logs in or creates account via notifs
    func onLoginGetMessages() {
        MessageService.instance.findAllChannels { (success) in
            if success {
                if MessageService.instance.channels.count > 0 {
                    MessageService.instance.selectedChannel = MessageService.instance.channels[0]
                    self.updateWithChannel()
                } else {
                    self.channelNameLbl.text = "No channels yet"
                }
            }
        }
    }
    
    func getMessages() {
        guard let channelId = MessageService.instance.selectedChannel?.id else { return }
        MessageService.instance.findAllMessagesForChannel(channelId: channelId) { (success) in
            if success {
                self.tableView.reloadData()
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.messages.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageCell {
            let message = MessageService.instance.messages[indexPath.row]
            cell.configureCell(message: message)
            return cell
        } else {
            return UITableViewCell()
        }
    }

}
