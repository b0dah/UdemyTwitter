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
    
    func fetchTweets(completion: @escaping ([Tweet]) -> Void) {
        var tweets = [Tweet]()
        
        TWEETS_REF.observe(.childAdded) { snapshot in
            
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let userID = dictionary["uid"] as? String else { return }
            let tweetID = snapshot.key
            
            UserService.shared.fetchUser(uid: userID) { user in
                let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                tweets.append(tweet)
                print("completion")
                completion(tweets)
            }
            
            
        }
    }
}
