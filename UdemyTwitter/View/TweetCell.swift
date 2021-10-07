//
//  TweetCell.swift
//  UdemyTwitter
//
//  Created by Иван Романов on 23.09.2021.
//

import UIKit

protocol TweetCellDelegate: AnyObject {
    func handleProfileImageTapped(_ cell: TweetCell)
}

class TweetCell: UICollectionViewCell {
    
    // MARK:- Properties
    
    public var tweet: Tweet? {
        didSet {
            self.configureUI()
        }
    }
    
    weak var delegate: TweetCellDelegate?
    
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
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    } ()
    
    private let authorLabel = UILabel()
    
    private lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "comment"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(self.handleCommentButtonTapped), for: .touchUpInside)
        
        return button
    } ()
    
    private lazy var retweetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "retweet"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(self.handleRetweetButtonTapped), for: .touchUpInside)
        
        return button
    } ()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "like"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(self.handleLikeButtonTapped), for: .touchUpInside)
        
        return button
    } ()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "share"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        button.addTarget(self, action: #selector(self.handleShareButtonTapped), for: .touchUpInside)
        
        return button
    } ()
    
    
    
    // MARK:- LC
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureViewAppearence()
        self.setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Actions
    
    @objc private func handleCommentButtonTapped() {
        print("Comment!")
    }
    
    @objc private func handleRetweetButtonTapped() {
        print("Retweet!")
    }
    
    @objc private func handleLikeButtonTapped() {
        print("Like!")
    }
    
    @objc private func handleShareButtonTapped() {
        print("Share!")
    }
    
    
    // MARK:- Helpers
    
    private func configureViewAppearence() {
        backgroundColor = .white
    }
    
    
    private func setupSubviews() {
        
        // Profile Image
        self.addSubview(self.profileImageView)
        self.profileImageView.anchor(top: self.topAnchor,
                                     left: self.leftAnchor,
                                     paddingTop: 8,
                                     paddingLeft: 8)
        
        self.addSubview(self.captionLabel)
        
        // Author + Caption Label
        let stackView = UIStackView(arrangedSubviews: [authorLabel, captionLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        self.addSubview(stackView)
        stackView.anchor(top: self.profileImageView.topAnchor,
                         left: self.profileImageView.rightAnchor,
                         right: rightAnchor,
                         paddingLeft: 12,
                         paddingRight: 12)
        
        self.authorLabel.text = "AUUthprrr"
        self.captionLabel.text = "Caption Caption \n AUUthprrr"
        
        // Separator
        let separator = UIView()
        separator.backgroundColor = .systemGroupedBackground
        self.addSubview(separator)
        separator.anchor(left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, height: 1)
        
        // Bottom Buttons
        let buttonStackView = UIStackView(arrangedSubviews: [commentButton, retweetButton, likeButton, shareButton])
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 50
        self.addSubview(buttonStackView)
        buttonStackView.centerX(inView: self)
        buttonStackView.anchor(bottom: bottomAnchor, paddingBottom: 8)
        
    }
    
    private func configureUI() {
        guard let tweet = self.tweet else { return }
        let viewModel = TweetViewModel(tweet: tweet)
        
        self.captionLabel.text = viewModel.caption
        self.profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        self.authorLabel.attributedText = viewModel.authorInfoText
    }
    
    // MARK:- Action
    @objc private func profileImageTapped() {
        delegate?.handleProfileImageTapped(self)
    }
}
