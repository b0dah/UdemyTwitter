//
//  UserService.swift
//  UdemyTwitter
//
//  Created by Иван Романов on 20.09.2021.
//

import Firebase

struct UserService {
    
    // instance
    static let shared = UserService()
    
    // Singleton Structure
    private init() { }
    
    // Methods
    func fetchUser(completion: @escaping (User) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return } ; print("DB: current uid \(uid)")
        
        USERS_REF.child(uid).observeSingleEvent(of: .value) { snapshot in print(snapshot)
            
            print(snapshot.value)
    
            guard let userDataDictinary = snapshot.value as? [String: AnyObject] else { return }
            let user = User(uid: uid, dictinary: userDataDictinary)
            
            completion(user)
        }
    }
}
