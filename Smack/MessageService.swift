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
                    //print(self.channels[0].channelTitle)
                    print("THIS!! \(self.channels)")
                    completion(true)
                }
                
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
            
        }
        
    }
    
}
