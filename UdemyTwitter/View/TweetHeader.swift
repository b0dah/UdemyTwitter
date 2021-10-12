//
//  TweetHeader.swift
//  UdemyTwitter
//
//  Created by Иван Романов on 11.10.2021.
//

import UIKit

class TweetHeader: UICollectionReusableView {
    
    // MARK:- Properties
    
    var tweet: Tweet? {
        didSet {
            self.configureWithViewModel()
        }
    }
    
    // MARK:- Subviews
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48 / 2
        iv.backgroundColor = .twitterBlue
        
        iv.isUserInteractionEnabled = true
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.profileImageTapped))
        iv.addGestureRecognizer(recognizer)
        
        return iv
    } ()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.text = "Loading ..."
        
        return label
    } ()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .lightGray
        label.text = "Loading ..."
        
        return label
    } ()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.text = "Loading ... the tweet \n there is another line here"
        
        return label
    } ()
    
    private let dateTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textAlignment = .left
        label.textColor = .lightGray
        label.text = "6:21 PM"
        
        return label
    } ()
    
    private lazy var optionsButton: UIButton = {
        let button = UIButton()
        button.tintColor = .lightGray
        button.setImage(UIImage(named: "down_arrow_24pt"), for: .normal)
        button.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        
        return button
    } ()
    
    private var retweetsLabel = UILabel()
    
    private var likesLabel = UILabel()
    
    private lazy var statsView: UIView = {
        let v = UIView()
        
        // Top divider
        let topDivider = UIView()
        topDivider.backgroundColor = .systemGroupedBackground
        v.addSubview(topDivider)
        topDivider.anchor(top: v.topAnchor, left: v.leftAnchor, right: v.rightAnchor,
                          paddingLeft: 16, paddingRight: 16,
                          height: 1.0)
        
        // Labels inside a stack
        let stackView = UIStackView(arrangedSubviews: [retweetsLabel, likesLabel])
        stackView.axis = .horizontal
        stackView.spacing = 12
        
        v.addSubview(stackView)
        stackView.centerY(inView: v)
        stackView.anchor(left: v.leftAnchor, paddingLeft: 16)
        
        // Bottom divider
        let bottomDivider = UIView()
        bottomDivider.backgroundColor = .systemGroupedBackground
        v.addSubview(bottomDivider)
        bottomDivider.anchor(left: v.leftAnchor, bottom: v.bottomAnchor, right: v.rightAnchor,
                          paddingLeft: 16, paddingRight: 16,
                          height: 1.0)
        
        return v
    } ()
    
    private lazy var commentButton: UIButton = {
        let button = createActionButton(withImagename: "comment")
        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        
        return button
    } ()
    
    private lazy var retweetButton: UIButton = {
        let button = createActionButton(withImagename: "retweet")
        button.addTarget(self, action: #selector(handleRetweetTapped), for: .touchUpInside)
        
        return button
    } ()
    
    private lazy var likeButton: UIButton = {
        let button = createActionButton(withImagename: "like")
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        
        return button
    } ()
    
    private lazy var shareButton: UIButton = {
        let button = createActionButton(withImagename: "share")
        button.addTarget(self, action: #selector(handleShareTapped), for: .touchUpInside)
        
        return button
    } ()
    
    // MARK:- Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Helpers
    
    private func setupSubviews() {
        
        let authorLabelsStack = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel])
        authorLabelsStack.axis = .vertical
        authorLabelsStack.spacing = 0
        
        let topStackView = UIStackView(arrangedSubviews: [profileImageView, authorLabelsStack])
        // axis default to horizontal
        topStackView.spacing = 12
        
        self.addSubview(topStackView)
        topStackView.anchor(top: topAnchor, left: leftAnchor,
                                paddingTop: 16, paddingLeft: 16)
        
        
        self.addSubview(captionLabel)
        captionLabel.anchor(top: topStackView.bottomAnchor, left: leftAnchor, right: rightAnchor,
                            paddingTop: 20, paddingLeft: 16, paddingRight: 16)
        
        self.addSubview(dateTimeLabel)
        dateTimeLabel.anchor(top: captionLabel.bottomAnchor, left: leftAnchor,
                             paddingTop: 20, paddingLeft: 16)
        
        // Options button
        addSubview(optionsButton)
        optionsButton.centerY(inView: topStackView)
        optionsButton.anchor(right: rightAnchor, paddingRight: 12)
        
        // Stats View
        addSubview(statsView)
        statsView.anchor(top: dateTimeLabel.bottomAnchor, left: leftAnchor, right: rightAnchor,
                         paddingTop: 20,
                         height: 40)
        
        // Action Stack
        let actionStack = UIStackView(arrangedSubviews: [commentButton, retweetButton, likeButton, shareButton])
        actionStack.spacing = 72
        actionStack.distribution = .fillEqually
        
        addSubview(actionStack)
        actionStack.centerX(inView: self)
        actionStack.anchor(bottom: self.bottomAnchor, paddingBottom: 16)
    }
    
    private func createActionButton(withImagename imageName: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        
        return button
    }
    
    private func configureWithViewModel() {
        guard let tweet = self.tweet else { return }
        let viewModel = TweetViewModel(tweet: tweet)
        
        captionLabel.text = viewModel.caption
        fullnameLabel.text = viewModel.fullnameText
        usernameLabel.text = viewModel.usernameText
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        dateTimeLabel.text = viewModel.timeStamp
        
        retweetsLabel.attributedText = viewModel.retweetsAttributedString
        likesLabel.attributedText = viewModel.likesAttributedString
    }
    
    // MARK:- Actions
    
    @objc private func profileImageTapped() {
        
    }
    
    @objc private func showActionSheet() {
        
    }
    
    // Action Buttons Actions
    
    @objc private func handleCommentTapped() {
        
    }
    
    @objc private func handleRetweetTapped() {
        
    }
    
    @objc private func handleLikeTapped() {
        
    }
    
    @objc private func handleShareTapped() {
        
    }
}
