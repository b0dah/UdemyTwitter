//
//  UserService.swift
//  UdemyTwitter
//
//  Created by Иван Романов on 20.09.2021.
//

import Firebase

typealias DatabaseCompletion = ((Error?, DatabaseReference) -> Void)

struct UserService {
    
    // instance
    static let shared = UserService()
    
    // Singleton Structure
    private init() { }
    
    // Methods
    func fetchUser(uid: String, completion: @escaping (User) -> Void) {
        
        USERS_REF.child(uid).observeSingleEvent(of: .value) { snapshot in print(snapshot)
            guard let userDataDictinary = snapshot.value as? [String: AnyObject] else { return }
            let user = User(uid: uid, dictinary: userDataDictinary)
            
            completion(user)
        }
    }
    
    func fetchUsers(completion: @escaping ([User]) -> Void ) {
        
        var users = [User]()
        
        USERS_REF.observe(.childAdded) { snapshot in
            let uid = snapshot.key
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            
            let user = User(uid: uid, dictinary: dictionary)
            users.append(user)
            
            completion(users)
        }
    }
    
    func followUser(userToFollowID: String, completion: @escaping (Error?, DatabaseReference) -> Void) {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        
        USER_FOLLOWING_REF.child(currentUserID).updateChildValues([userToFollowID: 1]) { error, reference in
            USER_FOLLOWERS_REF.child(userToFollowID).updateChildValues([currentUserID: 1], withCompletionBlock: completion)
        }
    }
    
    func unfollowUser(userToUnfollowID: String, completion: @escaping (DatabaseCompletion)) {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }

        USER_FOLLOWING_REF.child(currentUserID).child(userToUnfollowID).removeValue { error, reference in
            USER_FOLLOWERS_REF.child(userToUnfollowID).child(currentUserID).removeValue(completionBlock: completion)
        }
    }
    
    func checkIfUserIsFollowed(userID: String,
                               completion: @escaping (Bool) -> Void) {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        
        USER_FOLLOWING_REF.child(currentUserID).child(userID).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
    }
    
    func fetchUserStats(uid: String, completion: @escaping (UserRelationStats) -> Void) {
        USER_FOLLOWERS_REF.child(uid).observeSingleEvent(of: .value) { snapshot in
            let followersCount = snapshot.children.allObjects.count
            
            print("FOLLOWERS COUNT: \(followersCount)")
            
            USER_FOLLOWING_REF.child(uid).observeSingleEvent(of: .value) { snapshot in
                let followingCount = snapshot.children.allObjects.count
                
                print("FOLLOWERS COUNT: \(followersCount), \(followingCount)")
                
                let stats = UserRelationStats(followers: followersCount, following: followingCount)
                completion(stats)
            }
        }
    }
}
