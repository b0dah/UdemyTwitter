//
//  TweetController.swift
//  UdemyTwitter
//
//  Created by Иван Романов on 11.10.2021.
//

import UIKit

fileprivate let headerIdentifier = "HeaderIdentifier"
fileprivate let tweetCellIdentifier = "TweetCellIdentifier"

class TweetController: UICollectionViewController {
    
    // MARK:- Properties
    
    private let tweet: Tweet
    
    private var replies: [Tweet] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    // MARK:- Lifecycle
    
    init(tweet: Tweet) {
        self.tweet = tweet
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureCollectionView()
        self.fetchReplies()
        print("DB: Tweet:: \(tweet.caption)")
    }
    
    // MARK:- Helpers
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(TweetHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: tweetCellIdentifier)
    }
    
    // MARK:- API
    
    private func fetchReplies() {
        TweetService.shared.fetchReplies(forTweet: self.tweet) { replies in
            self.replies = replies
        }
    }
    
    // MARK:- Actions
    
}

// MARK:- UICollectionViewDataSource

extension TweetController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.replies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tweetCellIdentifier, for: indexPath) as! TweetCell
        cell.tweet = replies[indexPath.row]
        
        return cell
    }
}

// MARK:- UICollecitonViewDelegate

extension TweetController {
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = self.collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: headerIdentifier,
            for: indexPath) as! TweetHeader
        header.tweet = tweet
        
        return header
    }
}

// MARK:- UICollectionViewFlowLayout

extension TweetController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let viewModel = TweetViewModel(tweet: self.tweet)
        let labelWidth = self.view.frame.width - 32
        let captionLabelHeight = viewModel.heightForCaptionLabel(withWidth: labelWidth, andForFontSize: 20)
        
        return CGSize(width: self.view.frame.width, height: captionLabelHeight + 227)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let tweet = self.replies[indexPath.row]
        let viewModel = TweetViewModel(tweet: tweet)
        let labelWidth = self.view.frame.width - 16 - 12 - 48
        let captionLabelHeight = viewModel.heightForCaptionLabel(withWidth: labelWidth, andForFontSize: 14)
        
        return CGSize(width: self.view.frame.width, height: captionLabelHeight + 70)
    }
}
