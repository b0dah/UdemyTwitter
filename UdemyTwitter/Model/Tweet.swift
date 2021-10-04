//
//  Tweet.swift
//  UdemyTwitter
//
//  Created by Иван Романов on 23.09.2021.
//

import Foundation

struct Tweet {
    
    let tweetID: String
    let caption: String
    let userID: String
    let likes: Int
    var timestamp: Date
    let retweetsCount: Int
    let user: User
    
    init(user: User, tweetID: String, dictionary: [String: Any]) {
        self.user = user
        
        self.tweetID = tweetID
        
        self.caption = dictionary["caption"] as? String ?? ""
        self.userID = dictionary["uid"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.retweetsCount = dictionary["retweets"] as? Int ?? 0
        
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        } else {
            self.timestamp = Date()
        }

    }
    
    
}
