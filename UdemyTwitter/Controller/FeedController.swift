//
//  FeedController.swift
//  UdemyTwitter
//
//  Created by Иван Романов on 13.09.2021.
//

import UIKit

class FeedController: UIViewController {
    
    // MARK:- Properties
    
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
        navigationItem.titleView = imageView
    }
}
