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
    
    private var timeSincePosted: String {
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
    
    public var fullnameText: String {
        author.fullname
    }
    
    public var usernameText: String {
        return "@\(author.username)"
    }
    
    public var authorInfoText: NSAttributedString {
        let title = NSMutableAttributedString(string: self.author.fullname,
                                              attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        title.append(NSAttributedString(string: " @\(author.username)",
                                        attributes: [.font: UIFont.systemFont(ofSize: 14),
                                                     .foregroundColor: UIColor.lightGray,
                                                    ]))
        
        title.append(NSAttributedString(string: " ・\(self.timeSincePosted)",
                                        attributes: [.font: UIFont.systemFont(ofSize: 14),
                                                     .foregroundColor: UIColor.lightGray,
                                                    ]))
        
        return title
    }
    
    public var caption: String {
        self.tweet.caption
    }
    
    public var timeStamp: String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "h:mm a ・ MM/dd/yyyy"
        return dateFormatter.string(from: tweet.timestamp)
    }
    
    public var retweetsAttributedString: NSAttributedString? {
        attributedText(withIntValue: tweet.retweetsCount, text: "Retweets")
    }
    
    public var likesAttributedString: NSAttributedString? {
        attributedText(withIntValue: tweet.likes, text: "Likes")
    }
    
    // MARK:- Helpers
    
    private func attributedText(withIntValue value: Int, text: String) -> NSAttributedString {
        
        let attributedText = NSMutableAttributedString(string: "\(value)",
                                                       attributes: [
                                                        .font: UIFont.boldSystemFont(ofSize: 14)
                                                       ])
        
        attributedText.append(NSAttributedString(string: " \(text)",
                                                    attributes: [
                                                        .font: UIFont.systemFont(ofSize: 14),
                                                        .foregroundColor: UIColor.lightGray
                                                    ]))
        
        return attributedText
    }
    
    func heightForCaptionLabel(withWidth width: CGFloat, andForFontSize fontSize: CGFloat) -> CGFloat {
        
        let labelToMeasure = UILabel()
        labelToMeasure.text = self.caption
        labelToMeasure.font = .systemFont(ofSize: fontSize)
        labelToMeasure.numberOfLines = 0
        labelToMeasure.lineBreakMode = .byWordWrapping
        labelToMeasure.translatesAutoresizingMaskIntoConstraints = false
        labelToMeasure.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        return labelToMeasure.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
    }
}
