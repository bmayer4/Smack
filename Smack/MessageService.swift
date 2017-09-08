//
//  MessageService.swift
//  Smack
//
//  Created by Brett Mayer on 9/5/17.
//  Copyright © 2017 Devslopes. All rights reserved.
//




//***** in lecture 82, 11 mins, JB shows us how to use swift 4 decoding protocol on Channel struct model to parse JSON
//new way, it is really cool actually but your model variables must be exactly named after json data in exact same order
import Foundation
import Alamofire
import SwiftyJSON

class MessageService {
    
    static let instance = MessageService()
    private init() {}
    
    var channels = [Channel]()
    var messages = [Message]()  //we're only storing messages for one channel at a time
    var selectedChannel: Channel?
    
    func findAllChannels(completion: @escaping CompletionHandler ) {
     
        Alamofire.request(URL_GET_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { return }
            
                if let json = JSON(data: data).array {
                    print(json)
                    for item in json {
                
                        let name = item["name"].stringValue
                        let channelDescription = item["description"].stringValue
                        let id = item["_id"].stringValue
                        
                        let channel = Channel(channelTitle: name, channelDescription: channelDescription, id: id)
                        self.channels.append(channel)
                        }
                    completion(true)
                }
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func findAllMessagesForChannel(channelId: String, completion: @escaping CompletionHandler) {
     
        Alamofire.request("\(URL_GET_MESSAGES)\(channelId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            self.clearMessages()
    
            if response.result.error == nil {
                guard let data = response.data else { return }
                
                if let json = JSON(data: data).array {
                    print(json)
                    for item in json {
                        
                        let messageBody = item["messageBody"].stringValue
                        let channelId = item["channelId"].stringValue
                        let id = item["_id"].stringValue
                        let userName = item["userName"].stringValue
                        let userAvatar = item["userAvatar"].stringValue
                        let userAvatarColor = item["userAvatarColor"].stringValue
                        let timeStamp = item["timestamp"].stringValue
                        
                        let message = Message(message: messageBody, userName: userName, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, timeStamp: timeStamp)
                        self.messages.append(message)
                    }
                    completion(true)
                }
            } else {
                debugPrint(response.result.error as Any)
                completion(false)
            }
        }
        
    }
    
    func clearMessages() {
        messages.removeAll()
    }
    
    
    //will be called in logout function is user data service
    func clearChannels() {
        channels.removeAll()
    }
    
}
