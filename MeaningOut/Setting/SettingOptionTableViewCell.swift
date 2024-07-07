//
//  SettingTableViewCell.swift
//  MeaningOut
//
//  Created by 권대윤 on 6/16/24.
//

import UIKit

import SnapKit

final class SettingOptionTableViewCell: BaseTableViewCell {
    
    //MARK: - Properties
    
    enum CellType: Int {
        case myLikeList = 1
        case commonQuestion
        case inquiry
        case notificationSetting
        case withdrawal
        
        var titleText: String {
            switch self {
            case .myLikeList:
                return "나의 장바구니 목록"
            case .commonQuestion:
                return "자주 묻는 질문"
            case .inquiry:
                return "1:1 문의"
            case .notificationSetting:
                return "알림 설정"
            case .withdrawal:
                return "탈퇴하기"
            }
        }
    }
    
    private let repository = ProductRepository()
    
    //MARK: - UI Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constant.Font.system14
        label.textColor = Constant.Color.primaryBlack
        label.textAlignment = .left
        return label
    }()
    
    private let likeCountButton: UIButton = {
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
    
    private func configureAttributedStringForLikeCountButton() {
        let likeCount = Array(repository.fetchAllItem()).count
        let attributeString = NSMutableAttributedString(string: "\(likeCount)개", attributes: [.font: UIFont.boldSystemFont(ofSize: 14), .foregroundColor: Constant.Color.primaryBlack])
        let addAttri = NSAttributedString(string: "의 상품", attributes: [.font: Constant.Font.system14, .foregroundColor: Constant.Color.primaryBlack])
        attributeString.append(addAttri)
        likeCountButton.setAttributedTitle(attributeString, for: .normal)
    }
    
    func cellConfig(type: CellType) {
        switch type {
        case .myLikeList:
            self.likeCountButton.isHidden = false
            self.titleLabel.text = type.titleText
            self.configureAttributedStringForLikeCountButton()
            self.selectionStyle = .default
        
        case .commonQuestion, .inquiry, .notificationSetting, .withdrawal:
            self.likeCountButton.isHidden = true
            self.titleLabel.text = type.titleText
            
            if type == .withdrawal {
                self.selectionStyle = .default
            } else {
                self.selectionStyle = .none
            }
        }
    }
}
