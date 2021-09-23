//
//  User.swift
//  UdemyTwitter
//
//  Created by Иван Романов on 20.09.2021.
//

import Foundation

struct User {
    
    let uid: String
    let fullname: String
    let email: String
    let username: String
    let profileImageUrl: String
    
    public init(uid: String, dictinary: [String: AnyObject]) {
        self.uid = uid
        
        self.fullname = dictinary["fullname"] as? String ?? ""
        self.email = dictinary["email"] as? String ?? ""
        self.username = dictinary["username"] as? String ?? ""
        self.profileImageUrl = dictinary["profileImageUrl"] as? String ?? ""
    }
}
