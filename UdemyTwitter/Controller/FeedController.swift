//
//  FeedController.swift
//  UdemyTwitter
//
//  Created by Иван Романов on 13.09.2021.
//

import UIKit
import SDWebImage

class FeedController: UIViewController {
    
    // MARK:- Properties
    
    public var user: User? {
        didSet {
            cofigureLeftBarButton() //print("DB: User is already in FeedController!")
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
        
        self.configureUI()
    }
    
    // MARK:- Helpers
    
    private func configureUI() {
        self.view.backgroundColor = .white
        
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(width: 44, height: 44)
        navigationItem.titleView = imageView
        
        
    }
    
    private func cofigureLeftBarButton() {
        guard let user = user else { return }
        guard let url = URL(string: user.profileImageUrl) else { return }
        // User Avatar on the left of Navigation Bar
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
        self.profileImageView.sd_setImage(with: url, completed: nil)
    }
}
