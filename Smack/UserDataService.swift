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
    
    func returnUIColor(components: String) -> UIColor {

        //the teacher did this a different way, using scanner. I am more comfortable with this way
        let removeLeftBracket = components.replacingOccurrences(of: "[", with: "")
        let removeRightBracket = removeLeftBracket.replacingOccurrences(of: "]", with: "")
        let removeSpaces = removeRightBracket.replacingOccurrences(of: " ", with: "")
        let colorArray = removeSpaces.components(separatedBy: ",")
        print(colorArray)
        guard let r = Double(colorArray[0]) else { return UIColor.lightGray }
        guard let g = Double(colorArray[1]) else { return UIColor.lightGray }
        guard let b = Double(colorArray[2]) else { return UIColor.lightGray }
        guard let a = Double(colorArray[3]) else { return UIColor.lightGray }
            print(r, g, b, a)
        
        let color = UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: CGFloat(a))
        
        return color
    }
    
    //called in 
    func logoutUser() {
        id = ""
        avatarColor = ""
        avatarName = ""
        email = ""
        name = ""
        
        AuthService.instance.isLoggedIn = false
        AuthService.instance.userEmail = ""
        AuthService.instance.authToken = ""
        MessageService.instance.clearChannels()
    }
    
    
    
}
