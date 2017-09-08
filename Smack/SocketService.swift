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
        //listening for an event of type channelCreated, got saved to database through api
        socket.on("channelCreated") { (dataArray, ack) in
    
            guard let channelName = dataArray[0] as? String else { return }
            guard let channeldesc = dataArray[1] as? String else { return }
            guard let channelId = dataArray[2] as? String else { return }
            
            let newChannel = Channel(channelTitle: channelName, channelDescription: channeldesc, id: channelId)
            MessageService.instance.channels.append(newChannel)
            
            completion(true)
        }
    }
    
    func addMessage(messageBody: String, userId: String, channelId: String, completion: @escaping CompletionHandler) {
        //sends information to the API
        let user = UserDataService.instance
        socket.emit("newMessage", messageBody, userId, channelId, user.name, user.avatarName, user.avatarColor)
        completion(true)
    }


}
