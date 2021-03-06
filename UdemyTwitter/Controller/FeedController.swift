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
            cofigureLeftBarButton()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barStyle = .default
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
        cell.delegate = self
        
        return cell
    }
}

// MARK:- UICollectionViewDelegate

extension FeedController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = TweetController(tweet: tweets[indexPath.row])
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK:- UICollectionViewDelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tweet = tweets[indexPath.row]
        let viewModel = TweetViewModel(tweet: tweet)
        let labelWidth = self.view.frame.width - 16 - 12 - 48
        let captionLabelHeight = viewModel.heightForCaptionLabel(withWidth: labelWidth, andForFontSize: 14)
        
        return CGSize(width: self.view.frame.width, height: captionLabelHeight + 70)
    }
}

// MARK:- TweetCellDelegate

extension FeedController: TweetCellDelegate {
    
    func handleProfileImageTapped(_ cell: TweetCell) {
        
        guard let user = cell.tweet?.user else { return }
        
        let profileController = ProfileController(user: user)
        self.navigationController?.pushViewController(profileController, animated: true)
    }
    
    func handleReplyTapped(_ cell: TweetCell) {
        guard let tweet = cell.tweet else { return }
        let controller = UploadTweetController(user: tweet.user, configuration: .reply(tweet))
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.modalPresentationStyle = .fullScreen
        
        present(navigationController, animated: true)
    }
}

