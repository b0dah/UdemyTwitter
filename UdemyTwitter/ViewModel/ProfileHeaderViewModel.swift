//
//  ProfileHeaderViewModel.swift
//  UdemyTwitter
//
//  Created by Иван Романов on 07.10.2021.
//

import UIKit
import Firebase

enum ProfileFilterOptions: Int, CaseIterable {
    case tweets
    case replies
    case likes
    
    var description: String {
        switch self {
        case .tweets: return "Tweets"
        case .replies: return "Tweets & Replies"
        case .likes: return "Likes"
        }
    }
}


struct ProfileheaderViewModel {
    
    private let user: User
    
    private var isCurrentUser: Bool {
        Auth.auth().currentUser?.uid == user.uid
    }
    
    init(user: User) {
        self.user = user
    }
    
    // MARK:- Public proprties
    
    public var profileImageUrl: URL? {
        self.user.profileImageUrl
    }
    
    public var fullnameString: String {
        self.user.fullname
    }
    
    public var usernameString: String {
        "@\(self.user.username)"
    }
    
    public var followingString: NSAttributedString? {
        attributedText(withIntValue: 0, text: " following")
    }
    
    public var followersString: NSAttributedString? {
        attributedText(withIntValue: 0, text: " followers")
    }
    
    
    
    
    
    
    
    public var actionButtonTitle: String {
        // if user user is current user then set to edit profile
        // else figure out if following / not following
        
        if isCurrentUser {
            return "Edit Profile"
        } else {
            return "Follow"
        }
    }
    
    // MARK:- Helpers
    
    private func attributedText(withIntValue value: Int, text: String) -> NSAttributedString {
        
        let attributedText = NSMutableAttributedString(string: "\(value)",
                                                       attributes: [
                                                        .font: UIFont.boldSystemFont(ofSize: 14)
                                                       ])
        
        attributedText.append(NSAttributedString(string: "\(text)",
                                                    attributes: [
                                                        .font: UIFont.systemFont(ofSize: 14),
                                                        .foregroundColor: UIColor.lightGray
                                                    ]))
        
        return attributedText
    }
}
