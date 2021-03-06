//
//  MainTabController.swift
//  UdemyTwitter
//
//  Created by Иван Романов on 10.09.2021.
//

import UIKit
import Firebase

class MainTabController: UITabBarController {
    
    // MARK:- Properties
    
    var user: User? {
        didSet {
            guard let nav = viewControllers?.first as? UINavigationController else { return }
            guard let feed = nav.viewControllers.first as? FeedController else { return }
            feed.user = self.user
        }
    }
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .twitterBlue
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        button.addTarget(self, action: #selector(handleActionButtonTap), for: .touchUpInside)
        
        return button
    } ()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .twitterBlue
        self.checkAuthenticationAndConfigureUI()
    }
    
    // MARK:- Helpers
    
    private func configureUI() {
        self.view.addSubview(self.actionButton)
        self.actionButton.setDimensions(width: 56, height: 56)
        self.actionButton.anchor(bottom: self.view.safeAreaLayoutGuide.bottomAnchor, right: self.view.rightAnchor,
                                 paddingBottom: 64, paddingRight: 16)
        self.actionButton.layer.cornerRadius = 56 / 2
    }
    
    private func configureViewControllers() {
        
        let feed = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let feedNavigationController = createTemplateNavigationController(image: UIImage(named: "home_unselected"), rootViewController: feed)
        
        let explore = ExploreController()
        let exploreNavigationController = createTemplateNavigationController(image: UIImage(named: "search_unselected"), rootViewController: explore)
        
        let notifications = NotificationsController()
        let notificationsNavigationController = createTemplateNavigationController(image: UIImage(named: "like_unselected"), rootViewController: notifications)
        
        let conversations = ConversationsController()
        let conversationsNavigationController = createTemplateNavigationController(image: UIImage(named: "ic_mail_outline_white_2x-1"), rootViewController: conversations)
        
        self.viewControllers = [feedNavigationController, exploreNavigationController, notificationsNavigationController, conversationsNavigationController]
    }
    
    private func createTemplateNavigationController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        
        let navigation = UINavigationController(rootViewController: rootViewController)
        navigation.tabBarItem.image = image
        navigation.navigationBar.barTintColor = .white
        
        return navigation
    }
    
    // MARK:- API
    
    public func fetchCurrentUser() {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        UserService.shared.fetchUser(uid: currentUserID, completion: { user in
            self.user = user
        })
    }
    
    public func checkAuthenticationAndConfigureUI() {
        if Auth.auth().currentUser == nil {
            print("DB: User is not logged in")
            DispatchQueue.main.async {
                let loginNavigationController = UINavigationController(rootViewController: LoginController())
                loginNavigationController.modalPresentationStyle = .fullScreen
                self.present(loginNavigationController, animated: true, completion: nil)
            }
        } else {
            print("DB: User id logged in")
            
            self.configureViewControllers()
            self.configureUI()
            self.fetchCurrentUser()
        }
    }
    
    func logUserOut() {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print("DB: Failed to sign out with error: \(error.localizedDescription) ")
        }
    }
    
    // MARK:- Actions
    
    @objc private func handleActionButtonTap() {
        guard let user = user else { return }
        let uploadTweetController = UploadTweetController(user: user, configuration: .tweet)
        let navigationController = UINavigationController(rootViewController: uploadTweetController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
}
