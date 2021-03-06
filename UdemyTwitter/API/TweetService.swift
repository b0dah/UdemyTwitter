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
    
    func uploadTweet(type: UploadTweetConfiguration, caption: String, completion: @escaping (DatabaseCompletion)) {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        
        let currentTimestamp = Int(Date().timeIntervalSince1970)
        
        let values = [
            "uid": currentUserID,
            "timestamp": currentTimestamp,
            "likes": 0,
            "retweets": 0,
            "caption": caption
        ] as [String: Any]
        
        switch type {
        case .tweet:
            // Upload a regular tweet
            let tweetByAutoIDReference = TWEETS_REF.childByAutoId()
            tweetByAutoIDReference.updateChildValues(values) { error, reference in
                // upload user tweet structure after tweet upload completes
                guard let tweetID = tweetByAutoIDReference.key else { return }
                let valuesToPut = [tweetID: 1]
                USER_TWEETS_REF.child(currentUserID).updateChildValues(valuesToPut, withCompletionBlock: completion)
            }
        case .reply(let tweet):
            TWEET_REPLIES_REF.child(tweet.tweetID).childByAutoId()
                .updateChildValues(values, withCompletionBlock: completion)
        }
        
        
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
                completion(tweets)
            }
            
            
        }
    }
    
    func fetchTweets(forUser user: User, completion: @escaping ([Tweet])->Void ) {
        
        var tweets = [Tweet]()
        
        USER_TWEETS_REF.child(user.uid).observe(.childAdded) { snapshot in
            let tweetID = snapshot.key
            TWEETS_REF.child(tweetID).observeSingleEvent(of: .value) { tweetDetailsSnapshot in
                guard let dictionary = tweetDetailsSnapshot.value as? [String: Any] else { return }
                
                let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    func fetchReplies(forTweet tweet: Tweet, completion: @escaping ([Tweet]) -> Void) {
        
        var tweets = [Tweet]()
        
        TWEET_REPLIES_REF.child(tweet.tweetID).observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            let tweetID = snapshot.key
            
            UserService.shared.fetchUser(uid: uid) { user in
                let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
}
