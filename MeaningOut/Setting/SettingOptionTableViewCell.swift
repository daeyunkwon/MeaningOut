//
//  SettingTableViewCell.swift
//  MeaningOut
//
//  Created by 권대윤 on 6/16/24.
//

import UIKit

import SnapKit

final class SettingOptionTableViewCell: BaseTableViewCell {
    
    //MARK: - UI Components
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constant.Font.system14
        label.textColor = Constant.Color.primaryBlack
        label.textAlignment = .left
        return label
    }()
    
    let likeCountButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "like_selected")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return btn
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = Constant.Color.primaryGray
        return view
    }()
    
    //MARK: - Init
    
    override func configureLayout() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.leading.equalTo(contentView.snp.leading)
        }
        
        contentView.addSubview(likeCountButton)
        likeCountButton.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.trailing.equalTo(contentView.snp.trailing)
        }
        
        contentView.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView.snp.horizontalEdges)
            make.bottom.equalTo(contentView.snp.bottom)
            make.height.equalTo(1)
        }
    }
    
    //MARK: - Functions
    
    func configureAttributedStringForLikeCountButton() {
        let likeCount = UserDefaultsManager.shared.like?.count ?? 0
        let attributeString = NSMutableAttributedString(string: "\(likeCount)개", attributes: [.font: UIFont.boldSystemFont(ofSize: 14), .foregroundColor: Constant.Color.primaryBlack])
        let addAttri = NSAttributedString(string: "의 상품", attributes: [.font: Constant.Font.system14, .foregroundColor: Constant.Color.primaryBlack])
        attributeString.append(addAttri)
        likeCountButton.setAttributedTitle(attributeString, for: .normal)
    }
}
