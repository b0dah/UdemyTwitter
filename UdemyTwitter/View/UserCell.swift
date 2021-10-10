//
//  UserCell.swift
//  UdemyTwitter
//
//  Created by Иван Романов on 08.10.2021.
//

import UIKit

class UserCell: UITableViewCell {
    
    // MARK:- Properties
    
    public var user: User? {
        didSet { self.configureWithViewModel() }
    }
    
    // MARK:- Subviews
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.setDimensions(width: 40, height: 40)
        iv.layer.cornerRadius = 40 / 2
        iv.backgroundColor = .twitterBlue
        
        return iv
    } ()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.text = "Username"
        
        return label
    } ()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.text = "Fullname"
        
        return label
    } ()
    
    // MARK:- Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Helpers
    
    private func configureSubviews() {
        addSubview(profileImageView)
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        
        let labelsStackView = UIStackView(arrangedSubviews: [usernameLabel, fullnameLabel])
        labelsStackView.axis = .vertical
        labelsStackView.spacing = 2
        addSubview(labelsStackView)
        labelsStackView.centerY(inView: self, leftAnchor: profileImageView.rightAnchor, paddingLeft: 12)
        
    }
    
    private func configureWithViewModel() {
        guard let user = user else { return }
        
        profileImageView.sd_setImage(with: user.profileImageUrl)
        self.usernameLabel.text = user.username
        self.fullnameLabel.text = user.fullname
    }
}
