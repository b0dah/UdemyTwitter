//
//  TweetViewModel.swift
//  UdemyTwitter
//
//  Created by Иван Романов on 04.10.2021.
//

import UIKit

class TweetViewModel {
    
    let tweet: Tweet
    let author: User
    
    init(tweet: Tweet) {
        self.tweet = tweet
        self.author = tweet.user
    }
    
    private var timestamp: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        
        let now = Date()
        
        return formatter.string(from: tweet.timestamp, to: now) ?? ""
    }
    
    // MARK:- Properties
    
    public var profileImageUrl: URL? {
        self.author.profileImageUrl
    }
    
    public var authorInfoText: NSAttributedString {
        let title = NSMutableAttributedString(string: self.author.fullname,
                                              attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        title.append(NSAttributedString(string: " @\(author.username)",
                                        attributes: [.font: UIFont.systemFont(ofSize: 14),
                                                     .foregroundColor: UIColor.lightGray,
                                                    ]))
        
        title.append(NSAttributedString(string: " ・\(self.timestamp)",
                                        attributes: [.font: UIFont.systemFont(ofSize: 14),
                                                     .foregroundColor: UIColor.lightGray,
                                                    ]))
        
        return title
    }
    
    public var caption: String {
        self.tweet.caption
    }
    
    
}
