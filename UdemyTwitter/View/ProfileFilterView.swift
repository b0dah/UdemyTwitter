//
//  ProfileFilterView.swift
//  UdemyTwitter
//
//  Created by Иван Романов on 05.10.2021.
//

import UIKit

fileprivate let cellIdentifier = "ProfileFilterCellIdentifier"

protocol ProfileFilterViewDelegate: AnyObject {
    func filterView(_ view: ProfileFilterView, didSelect indexPath: IndexPath)
}

class ProfileFilterView: UIView {
    
    // MARK:- Properties
    
    private let numberOfOptions = ProfileFilterOptions.allCases.count
    
    public lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        
        return cv
    } ()
    
    weak var delegate: ProfileFilterViewDelegate?
    
    // MARK:- Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.collectionView.register(ProfileFilterCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        addSubview(self.collectionView)
        self.collectionView.addConstraintsToFillView(self)
        
        // Select first cell
        let selectedCellIndex = IndexPath(row: 0, section: 0)
        self.collectionView.selectItem(at: selectedCellIndex, animated: true, scrollPosition: .left)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- UICollectionViewDataSource

extension ProfileFilterView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfOptions
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ProfileFilterCell
        let option = ProfileFilterOptions(rawValue: indexPath.row)
        cell.option = option
        return cell
    }
}

// MARK:- UICollectionViewDelegate

extension ProfileFilterView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.filterView(self, didSelect: indexPath)
    }
}

// MARK:- UICollectionViewDelegateFlowLayout

extension ProfileFilterView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / CGFloat(numberOfOptions), height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
