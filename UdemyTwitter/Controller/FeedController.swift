//
//  FeedController.swift
//  UdemyTwitter
//
//  Created by Иван Романов on 13.09.2021.
//

import UIKit
import SDWebImage

fileprivate let tweetCellReuseID = "tweetCellReuseID"

class FeedController: UICollectionViewController {
    
    // MARK:- Properties
    
    public var user: User? {
        didSet {
            cofigureLeftBarButton() //print("DB: User is already in FeedController!")
        }
    }
    
    private var tweets: [Tweet] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    // MARK:- Subviews
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.setDimensions(width: 32, height: 32)
        iv.layer.cornerRadius = 32 / 2
        iv.layer.masksToBounds = true
        
        return iv
    } ()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureController()
        self.configureUI()
        self.fetchTweets()
    }
    
    // MARK:- Helpers
    
    private func configureUI() {
        self.view.backgroundColor = .white
        self.collectionView.backgroundColor = .white
        
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(width: 44, height: 44)
        navigationItem.titleView = imageView
    }
    
    private func cofigureLeftBarButton() {
        guard let user = user else { return }
        guard let url = user.profileImageUrl else { return }
        // User Avatar on the left of Navigation Bar
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
        self.profileImageView.sd_setImage(with: url, completed: nil)
    }
    
    fileprivate func configureController() {
        self.collectionView.register(TweetCell.self, forCellWithReuseIdentifier: tweetCellReuseID)
        
    }
    
    // MARK:- API
    
    private func fetchTweets() {
        TweetService.shared.fetchTweets { tweets in
            self.tweets = tweets
        }
    }
}

// MARK:- UICollectionViewDataSource

extension FeedController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tweets.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tweetCellReuseID, for: indexPath) as! TweetCell
        cell.tweet = self.tweets[indexPath.row]
        
        return cell
    }
}

// MARK:- UICollectionViewDelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.width, height: 120)
    }
}

