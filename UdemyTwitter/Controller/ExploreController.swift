//
//  ExploreController.swift
//  UdemyTwitter
//
//  Created by Иван Романов on 13.09.2021.
//

import UIKit

class ExploreController: UIViewController {
    
    // MARK:- Properties
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
    }
    
    // MARK:- Helpers
    private func configureUI() {
        self.view.backgroundColor = .white
        self.navigationItem.title = "Explore"
    }
    
}
