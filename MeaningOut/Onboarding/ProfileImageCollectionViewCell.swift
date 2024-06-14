//
//  ProfileImageCollectionViewCell.swift
//  MeaningOut
//
//  Created by 권대윤 on 6/14/24.
//

import UIKit

import SnapKit

final class ProfileImageCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    enum ProfileType {
        case selected
        case unselected
    }
    var type = ProfileType.unselected
    
    var profile: UIImage? {
        didSet {
            self.profileImageView.image = profile
            layoutIfNeeded()
            
            switch type {
            case .selected:
                self.profileImageView.layer.borderColor = Constant.Color.primaryOrange.cgColor
                self.profileImageView.layer.borderWidth = 3
                self.profileImageView.alpha = 1
            case .unselected:
                self.profileImageView.layer.borderColor = Constant.Color.primaryLightGray.cgColor
                self.profileImageView.layer.borderWidth = 1
                self.profileImageView.alpha = 0.5
            }
        }
    }
    
    //MARK: - UI Components
    
    private let profileImageView = ProfileCircle()
    
    //MARK: - Life Cycle
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        profileImageView.layer.cornerRadius = profileImageView.bounds.size.width / 2
    }
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        contentView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
}