//
//  CaptionTextView.swift
//  UdemyTwitter
//
//  Created by Иван Романов on 23.09.2021.
//

import UIKit

class CaptionTextView: UITextView {
    
    // MARK:- Properties
    
    let placeHolderLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .gray
        label.text = "Waht's happening?"
        return label
    } ()
    
    // MARK:- Lifecycle
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        self.configure()
        self.configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Helpers
    
    fileprivate func configure() {
        self.backgroundColor = .white
        font = UIFont.systemFont(ofSize: 16)
        isScrollEnabled = false
        heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleTextInputChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    private func configureSubviews() {
        addSubview(placeHolderLabel)
        placeHolderLabel.anchor(top: topAnchor, left: leftAnchor,
                                paddingTop: 8, paddingLeft: 4)
    }
    
    // MARK:- Actions
    
    @objc private func handleTextInputChange() {
        placeHolderLabel.isHidden = !text.isEmpty
    }
    
}
