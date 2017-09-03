//
//  UserDataService.swift
//  Smack
//
//  Created by Brett Mayer on 9/2/17.
//  Copyright © 2017 Devslopes. All rights reserved.
//

import Foundation

class UserDataService {
    
    static let instance = UserDataService()
    
    private init() {}
    
    //all 5 of these variables will be received from the api endpoint
    //public getter var, but other classes can't set it
    public private(set) var id = ""
    public private(set) var avatarColor = ""
    public private(set) var avatarName = ""
    public private(set) var email = ""
    public private(set) var name = ""

    
    func setUserData(id: String, color: String, avatarName: String, email: String, name: String) {
        
        self.id = id
        self.avatarColor = color
        self.avatarName = avatarName
        self.email = email
        self.name = name
        
    }
    
    func setAvatarName(avatarName: String) {
        self.avatarName = avatarName
    }
    
    
}
