//
//  ProfileFilterCell.swift
//  UdemyTwitter
//
//  Created by Иван Романов on 05.10.2021.
//

import UIKit

class ProfileFilterCell: UICollectionViewCell {
    
    public var option: ProfileFilterOptions! {
        didSet {
            self.titleLabel.text = option.description
        }
    }
    
    // MARK:- Properties
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .lightGray
        label.text = "Filter"
        
        return label
    } ()
    
    override var isSelected: Bool {
        didSet {
            self.titleLabel.font = isSelected ? UIFont.boldSystemFont(ofSize: 16) : UIFont.systemFont(ofSize: 14)
            self.titleLabel.textColor = isSelected ? .twitterBlue : .lightGray
        }
    }
    
    // MARK:- Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(titleLabel)
        titleLabel.center(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
