//
//  ProfileCircle.swift
//  MeaningOut
//
//  Created by 권대윤 on 6/14/24.
//

import UIKit

import SnapKit

final class ProfileCircle: UIImageView {
    
    init(radius: CGFloat) {
        super.init(frame: .zero)
        configureUI()
        layer.cornerRadius = radius
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentMode = .scaleAspectFill
        layer.borderWidth = 1
        layer.borderColor = Constant.Color.primaryGray.cgColor
        image = UIImage(named: Constant.ProfileImage.profile_0.rawValue)
        alpha = 0.5
        clipsToBounds = true
    }
}
