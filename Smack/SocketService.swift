//
//  SocketService.swift
//  Smack
//
//  Created by Brett Mayer on 9/7/17.
//  Copyright © 2017 Devslopes. All rights reserved.
//

import UIKit
import SocketIO

class SocketService: NSObject {
    
    static let instance = SocketService()
    
    private override init() {}  //because NSObject, need to use override
        
    var socket: SocketIOClient = SocketIOClient(socketURL: URL(string: "https://chattychatchatapp.herokuapp.com/v1/")!)
    
    func establishConnection() {  //fire up in app delegate
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    //this will get called in AddChannelVC 
    func addChannel(channelName: String, channelDescription: String, completion: @escaping CompletionHandler) {
         //sends information to the API
        socket.emit("newChannel", channelName, channelDescription)
        completion(true)
    }
    
    
    //this will get called in ChannelVC viewDidLoad
    func getChannel(completion: @escaping CompletionHandler) {
        //listening for an event of type channelCreated, got saved to database through api in addChannel
        socket.on("channelCreated") { (dataArray, ack) in
    
            guard let channelName = dataArray[0] as? String else { return }
            guard let channeldesc = dataArray[1] as? String else { return }
            guard let channelId = dataArray[2] as? String else { return }
            
            let newChannel = Channel(channelTitle: channelName, channelDescription: channeldesc, id: channelId)
            MessageService.instance.channels.append(newChannel)
            
            completion(true)
        }
    }
    
    //sends to API and saves to database
    func addMessage(messageBody: String, userId: String, channelId: String, completion: @escaping CompletionHandler) {
        //sends information to the API
        let user = UserDataService.instance
        socket.emit("newMessage", messageBody, userId, channelId, user.name, user.avatarName, user.avatarColor)
        completion(true)
    }
    
    //we are listening for an event from the server called messageCreated
    func getChatMessage(completion: @escaping (_ newMessage: Message) -> Void) {
        socket.on("messageCreatated") { (dataArray, ack) in
            
            guard let messageBody = dataArray[0] as? String else { return }
            //guard let userId = dataArray[1] as? String else { return } we aren't storing this
            guard let channelId = dataArray[2] as? String else { return }
            guard let userName = dataArray[3] as? String else { return }
            guard let userAvatar = dataArray[4] as? String else { return }
            guard let userAvatarColor = dataArray[5] as? String else { return }
            guard let messageId = dataArray[6] as? String else { return }
            guard let timeStamp = dataArray[7] as? String else { return }
            
            let newMessage = Message(message: messageBody, userName: userName, channelId: channelId, userAvatar: userAvatar,userAvatarColor: userAvatarColor, id: messageId, timeStamp: timeStamp)
            
            completion(newMessage)  //return message to VC so it can add item to arraay and check which channel it is in
            
            }
    }
    
    //
    func getTypingUsers(_ completionHandler: @escaping (_ typingUsers: [String: String]) -> Void) {
        
        socket.on("userTypingUpdate") { (dataArray, ack) in
            guard let typingUsers = dataArray[0] as? [String: String] else { return }
            completionHandler(typingUsers)
        }
        
    }


}
