//
//  AuthService.swift
//  UdemyTwitter
//
//  Created by Иван Романов on 17.09.2021.
//

import Foundation
import Firebase

struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct AuthService {
    
    static let shared = AuthService()
    
    private init() { }
    
    // MARK:- Functions
    
    func logUserin(withEmail email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func registerUser(credentials: AuthCredentials, completion: @escaping (Error?, DatabaseReference) -> Void ) {
        
        // Image Stuff
        let profileImage = credentials.profileImage
        
        guard let imageData = profileImage.jpegData(compressionQuality: 0.3) else { return }
        let filename = NSUUID().uuidString
        let storageFileRef = STORAGE_PROFILE_IMAGES.child(filename)
        
        // Upload image to Firebase
        storageFileRef.putData(imageData, metadata: nil) { metaData, error in
            // Then get image gloabal url
            storageFileRef.downloadURL { url, error in
                guard let profileImageUrl = url?.absoluteString else { return }
                
                // Create User with All this Data
                Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { result, error in
                    if let error = error {
                        print("Debug: ", error.localizedDescription)
                        return
                    }
                    
                    guard let uid = result?.user.uid else { return }

                    let globalUser = USERS_REF.child(uid)
                    
                    let values = ["email": credentials.email,
                                  "username": credentials.username,
                                  "fullname": credentials.fullname,
                                  "profileImageUrl": profileImageUrl
                                 ]

                    globalUser.updateChildValues(values, withCompletionBlock: completion)
                }
            }
        }
    }
}
