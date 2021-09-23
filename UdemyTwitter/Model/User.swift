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
    let profileImageUrl: URL?
    
    public init(uid: String, dictinary: [String: AnyObject]) {
        self.uid = uid
        
        self.fullname = dictinary["fullname"] as? String ?? ""
        self.email = dictinary["email"] as? String ?? ""
        self.username = dictinary["username"] as? String ?? ""
        
        if let stringUrl = dictinary["profileImageUrl"] as? String,
           let url = URL(string: stringUrl) {
            self.profileImageUrl = url
        } else {
            self.profileImageUrl = nil
        }
    }
}
