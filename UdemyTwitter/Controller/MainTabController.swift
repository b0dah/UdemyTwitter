//
//  MainTabController.swift
//  UdemyTwitter
//
//  Created by Иван Романов on 10.09.2021.
//

import UIKit

class MainTabController: UITabBarController {
    
    // MARK:- Properties
    
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
        
        self.configureViewControllers()
        
        self.configureUI()
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
        
        let feed = FeedController()
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
    
    // MARK:- Actions
    
    @objc private func handleActionButtonTap() {
        print("tapped")
    }
}
