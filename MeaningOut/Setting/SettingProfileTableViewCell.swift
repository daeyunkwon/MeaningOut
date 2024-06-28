//
//  SettingProfileTableViewCell.swift
//  MeaningOut
//
//  Created by 권대윤 on 6/16/24.
//

import UIKit

import SnapKit

final class SettingProfileTableViewCell: BaseTableViewCell {
    
    //MARK: - UI Components
    
    private let profileImageView: UIImageView = {
        let iv = ProfileCircle(radius: 35, imageName: UserDefaultsManager.shared.profile ?? "")
        iv.layer.borderColor = Constant.Color.signatureColor.cgColor
        iv.layer.borderWidth = 3
        iv.alpha = 1
        return iv
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        label.textColor = Constant.Color.primaryBlack
        label.text = UserDefaultsManager.shared.nickname ?? ""
        return label
    }()
    
    private let joinDateLabel: UILabel = {
        let label = UILabel()
        label.font = Constant.Font.system13
        label.textColor = Constant.Color.primaryGray
        let date = UserDefaultsManager.shared.joinDate ?? ""
        label.text = "\(date) 가입"
        return label
    }()
    
    private let chevronRightMark: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("", for: .normal)
        btn.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        btn.tintColor = Constant.Color.primaryGray
        return btn
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = Constant.Color.primaryGray
        return view
    }()
    
    //MARK: - Init
    
    override func configureLayout() {
        contentView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.width.height.equalTo(70)
        }
        
        contentView.addSubview(usernameLabel)
        usernameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY).offset(-10)
            make.leading.equalTo(profileImageView.snp.trailing).offset(15)
        }
        
        contentView.addSubview(joinDateLabel)
        joinDateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY).offset(10)
            make.leading.equalTo(profileImageView.snp.trailing).offset(15)
        }
        
        contentView.addSubview(chevronRightMark)
        chevronRightMark.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.trailing.equalTo(contentView.snp.trailing)
            make.width.height.equalTo(30)
        }
        
        contentView.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView.snp.horizontalEdges)
            make.bottom.equalTo(contentView.snp.bottom)
            make.height.equalTo(1)
        }
    }
    
    override func configureUI() {
        self.profileImageView.image = UIImage(named: UserDefaultsManager.shared.profile ?? "")
        self.usernameLabel.text = UserDefaultsManager.shared.nickname
        self.selectionStyle = .default
    }
}
