//
//  UploadTweetController.swift
//  UdemyTwitter
//
//  Created by Иван Романов on 23.09.2021.
//

import UIKit

class UploadTweetController: UIViewController {
    
    // MARK:- Properties
    private let user: User
    private let configuration: UploadTweetConfiguration
    private lazy var viewModel = UploadTweetViewModel(config: self.configuration)
    
    // MARK:- Subviews
    
    private lazy var doneActionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .twitterBlue
        button.setTitle("Tweettttt", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        button.layer.cornerRadius = 32 / 2
        button.addTarget(self, action: #selector(handleUploadTweet), for: .touchUpInside)
        
        return button
    } ()
    
    private lazy var replyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.text = "replying to @---------"
        label.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        
        return label
    } ()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48 / 2
        
        return iv
    } ()
    
    private let captionTextView = CaptionTextView()
    
    // MARK:- Lifecycle
    
    init(user: User, configuration: UploadTweetConfiguration) {
        self.user = user
        self.configuration = configuration
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureNavigationBar()
        self.configureViewAppearence()
        self.setupSubviews()
        self.configureWithViewModel()
    }
    
    // MARK:- Actions
    
    @objc private func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleUploadTweet() {
        guard let caption = self.captionTextView.text else { return }
        TweetService.shared.uploadTweet(type: self.configuration, caption: caption) {
            error, databaseReference in
            
            if let error = error {
                print("DB: Failed to upload tweet with error: \(error.localizedDescription)")
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK:- API
    
    
    // MARK:- Helpers
    
    private func configureViewAppearence() {
        self.view.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
    }
    
    private func setupSubviews() {
        
        let imageCaptionStackView = UIStackView(arrangedSubviews: [profileImageView, captionTextView])
        imageCaptionStackView.axis = .horizontal
        imageCaptionStackView.spacing = 12
        
        let mainStack = UIStackView(arrangedSubviews: [replyLabel, imageCaptionStackView])
        mainStack.axis = .vertical
        mainStack.spacing = 12
        
        self.view.addSubview(mainStack)
        mainStack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: self.view.rightAnchor,
                                     paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        self.profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
    }
    
    private func configureWithViewModel() {
        doneActionButton.setTitle(viewModel.actionButtonTitle, for: .normal)
        captionTextView.placeHolderLabel.text = viewModel.placeholderText
        replyLabel.isHidden = !viewModel.shouldShowReplyLabel
        if let replyText = viewModel.replyText {
            replyLabel.text = replyText
        }
    }
    
    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.doneActionButton)
    }
}
