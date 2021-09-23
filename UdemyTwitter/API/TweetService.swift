//
//  TweetService.swift
//  UdemyTwitter
//
//  Created by Иван Романов on 23.09.2021.
//

import Firebase

struct TweetService {
    
    static let shared = TweetService()
    
    private init() { }
    
    func uploadTweet(caption: String, completion: @escaping (Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let currentTimestamp = Int(Date().timeIntervalSince1970)
        
        let values = [
            "uid": uid,
            "timestamp": currentTimestamp,
            "likes": 0,
            "retweets": 0,
            "caption": caption
        ] as [String: Any]
        
        // Upload tweet
        TWEETS_REF.childByAutoId().updateChildValues(values, withCompletionBlock: completion)
    }
}
