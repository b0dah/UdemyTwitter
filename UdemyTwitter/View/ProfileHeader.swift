//
//  ProfileHeader.swift
//  UdemyTwitter
//
//  Created by Иван Романов on 04.10.2021.
//

import UIKit

protocol ProfileHeaderDelegate: AnyObject {
    func handleDismissTapped()
    func handleEditProfileOrFollow(_ header: ProfileHeader)
}

class ProfileHeader: UICollectionReusableView {
    
    // MARK:- Properties
    
    var user: User? {
        didSet {
            self.configureContentWithViewModel()
        }
    }
    
    public weak var delegate: ProfileHeaderDelegate?
    
    // MARK:- Subviews
    
    private lazy var backgroundContainerView: UIView = {
        let v = UIView()
        v.backgroundColor = .twitterBlue
        
        v.addSubview(self.backButton)
        self.backButton.anchor(top: v.topAnchor, left: v.leftAnchor,
                               paddingTop: 42, paddingLeft: 16)
        self.backButton.setDimensions(width: 30, height: 30)
        
        return v
    } ()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "baseline_arrow_back_white_24dp")?
                            .withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(self.handleDismissal), for: .touchUpInside)
        
        return button
    } ()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderWidth = 4
        iv.layer.borderColor = UIColor.white.cgColor
        
        iv.setDimensions(width: 80, height: 80)
        iv.layer.cornerRadius = 80/2
        
        return iv
    } ()
    
    private lazy var editProfileOrFollowButton: UIButton = {
        
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Loading", for: .normal)
        
        button.layer.borderWidth = 1.25
        button.layer.borderColor = UIColor.twitterBlue.cgColor
        
        button.setTitleColor(.twitterBlue, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        
        button.setDimensions(width: 100, height: 36)
        button.layer.cornerRadius = 36 / 2
        
        button.addTarget(self, action: #selector(self.editProfileOrFollowButtonTapped), for: .touchUpInside)
        
        return button
    } ()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
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
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines = 3
        label.text = "Loading ..."
        
        return label
    } ()
    
    private lazy var filtersBarView: ProfileFilterView = {
        let v = ProfileFilterView()
        v.delegate = self
        
        return v
    } ()
    
    private let underlineView: UIView = {
        let v = UIView()
        v.backgroundColor = .twitterBlue
        
        return v
    } ()
    
    private let followingLabel: UILabel = {
        let label = UILabel()
        
        label.isUserInteractionEnabled = true
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleFollowingTapped))
        label.addGestureRecognizer(recognizer)
        
        label.text = "0 Following"
        
        return label
    } ()
    
    private let followersLabel: UILabel = {
        let label = UILabel()
        
        label.isUserInteractionEnabled = true
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleFollowersTapped))
        label.addGestureRecognizer(recognizer)
        
        label.text = "0 Following"
        
        return label
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
        
        // Back Container
        self.addSubview(self.backgroundContainerView)
        backgroundContainerView.anchor(top: self.topAnchor,
                          left: self.leftAnchor,
                          right: self.rightAnchor,
                          height: 108)
        
        // Profile Image
        self.addSubview(self.profileImageView)
        self.profileImageView.anchor(top: self.backgroundContainerView.bottomAnchor, left: self.leftAnchor,
                                     paddingTop: -24, paddingLeft: 8)
        
        // Edit Profile or Follow Button
        self.addSubview(self.editProfileOrFollowButton)
        self.editProfileOrFollowButton.anchor(top: self.backgroundContainerView.bottomAnchor,
                                              right: self.rightAnchor,
                                              paddingTop: 12,
                                              paddingRight: 25)
        
        // User Info Stack
        let userInfoStack = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel, bioLabel])
        userInfoStack.axis = .vertical
        userInfoStack.distribution = .fillProportionally
        userInfoStack.spacing = 4
        
        self.addSubview(userInfoStack)
        userInfoStack.anchor(top: self.profileImageView.bottomAnchor,
                             left: self.leftAnchor,
                             right: self.rightAnchor,
                             paddingTop: 8, paddingLeft: 12, paddingRight: 12)
        
        // Following / Followers
        let followStack = UIStackView(arrangedSubviews: [followingLabel, followersLabel])
        followStack.axis = .horizontal
        followStack.spacing = 8
        followStack.distribution = .fillEqually
        
        addSubview(followStack)
        followStack.anchor(top: userInfoStack.bottomAnchor, left: leftAnchor,
                           paddingTop: 8, paddingLeft: 12)
        
        // Filters Bar
        self.addSubview(self.filtersBarView)
        self.filtersBarView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 50)
        
        // Underline View
        addSubview(underlineView)
        underlineView.anchor(left: leftAnchor, bottom: bottomAnchor, width: frame.width / 3, height: 3)
        
    }
    
    private func configureContentWithViewModel() {
        guard let user = user else { return }
        
        let viewModel = ProfileheaderViewModel(user: user)
        
        self.profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        self.fullnameLabel.text = viewModel.fullnameString
        self.usernameLabel.text = viewModel.usernameString
        self.editProfileOrFollowButton.setTitle(viewModel.actionButtonTitle, for: .normal)
        
        self.followingLabel.attributedText = viewModel.followingString
        self.followersLabel.attributedText = viewModel.followersString
        
        
    }
    
    // MARK:- Actions
    
    @objc private func handleDismissal() {
        self.delegate?.handleDismissTapped()
    }
    
    @objc private func editProfileOrFollowButtonTapped() {
        delegate?.handleEditProfileOrFollow(self)
    }
    
    @objc private func handleFollowingTapped() {
        
    }
    
    @objc private func handleFollowersTapped() {
        
    }
    
//    // MARK:- Public Methods
//    public func setFollowButtonTitle(title: String) {
//        self.editProfileOrFollowButton.setTitle(title, for: .normal)
//    }
}

// MARK:- ProfileFilterViewDelegate

extension ProfileHeader: ProfileFilterViewDelegate {
    func filterView(_ view: ProfileFilterView, didSelect indexPath: IndexPath) {
        guard let cell = view.collectionView.cellForItem(at: indexPath) as? ProfileFilterCell else { return }
        
        let xPosition = cell.frame.minX
        UIView.animate(withDuration: 0.3) {
            self.underlineView.frame.origin.x = xPosition
        }
    }
}
