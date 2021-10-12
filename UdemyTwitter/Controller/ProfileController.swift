//
//  ProfileController.swift
//  UdemyTwitter
//
//  Created by Иван Романов on 04.10.2021.
//

import UIKit

fileprivate let collectionViewCellIdentifier = "CollectionViewCellIdentifier"
fileprivate let collectionViewHeaderIdentifier = "CollectionViewHeaderIdentifier"

class ProfileController: UICollectionViewController {
    
    // MARK:- Properties
    
    private var user: User
    
    private var tweets: [Tweet] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    private weak var collectionViewHeader: ProfileHeader!
    
    // MARK:- Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureCollectionView()
        self.checkIfUserIsFollowed()
        self.fetchUserStats()
        self.fetchTweets()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.barStyle = .black
    }
    
    // MARK:- Helpers
    
    private func configureViewAppearence() {
        
    }
    
    private func configureCollectionView() {
        self.collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: collectionViewCellIdentifier)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: collectionViewHeaderIdentifier)
    }
    
    // MARK:- API
    
    private func fetchTweets() {
        TweetService.shared.fetchTweets(forUser: self.user) { tweets in
            self.tweets = tweets
        }
    }
    
    private func checkIfUserIsFollowed() {
        UserService.shared.checkIfUserIsFollowed(userID: user.uid) { isFollowed in
            self.user.isFollowed = isFollowed
            
            self.collectionView.reloadData()
        }
    }
    
    private func fetchUserStats() {
        UserService.shared.fetchUserStats(uid: user.uid) { stats in
            self.user.stats = stats
            self.collectionView.reloadData()
        }
    }
    
    // MARK:- Actions
    
}

// MARK:- UICollectionViewDataSource

extension ProfileController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellIdentifier, for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        
        return cell
    }
}

// MARK:- Header View

extension ProfileController {
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: collectionViewHeaderIdentifier, for: indexPath) as! ProfileHeader
        header.user = self.user
        header.delegate = self
        
        self.collectionViewHeader = header
        
        return header
    }
}

// MARK:- UICollectionViewDelegateFlowLayout

extension ProfileController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: self.view.frame.width, height: 350)
    }

}

// MARK:- ProfileHeaderDelegate

extension ProfileController: ProfileHeaderDelegate {
    
    func handleEditProfileOrFollow(_ header: ProfileHeader) {
        
        if self.user.isCurrentUser {
            print("Present Edit profile controller")
            return
        }
        
        if user.isFollowed {
            UserService.shared.unfollowUser(userToUnfollowID: self.user.uid) { error, db in
                self.user.isFollowed = false
                // Reload CV data to update button title
                self.collectionView.reloadData()
            }
        } else {
            UserService.shared.followUser(userToFollowID: self.user.uid) { error, db in
                self.user.isFollowed = true
                // Reload CV data to update button title
                self.collectionView.reloadData()
            }
        }
        
        
    }
    
    func handleDismissTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
