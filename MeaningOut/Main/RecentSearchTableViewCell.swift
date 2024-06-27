//
//  RecentSearchTableViewCell.swift
//  MeaningOut
//
//  Created by 권대윤 on 6/14/24.
//

import UIKit

import SnapKit

final class RecentSearchTableViewCell: BaseTableViewCell {

    //MARK: - Properties
    
    var recentSearch: String? {
        didSet {
            self.searchTitleLabel.text = recentSearch
        }
    }
    
    weak var delegate: RecentSearchTableViewCellDelegate?
    
    //MARK: - UI Components
    
    private let clockIconButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("", for: .normal)
        btn.tintColor = Constant.Color.primaryBlack
        btn.setImage(Constant.SymbolSize.smallBoldSize(systemName: "clock"), for: .normal)
        return btn
    }()
    
    private let searchTitleLabel: UILabel = {
        let label = UILabel()
        label.font = Constant.Font.system14
        label.textAlignment = .left
        label.text = "맥북 거치대"
        return label
    }()
    
    private lazy var removeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("", for: .normal)
        btn.tintColor = Constant.Color.primaryBlack
        btn.setImage(Constant.SymbolSize.smallSize(systemName: "xmark"), for: .normal)
        btn.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    //MARK: - Life Cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        searchTitleLabel.text = nil
    }
    
    //MARK: - Init
    
    override func configureLayout() {
        contentView.addSubview(clockIconButton)
        clockIconButton.snp.makeConstraints { make in
            make.height.width.equalTo(20)
            make.centerY.equalTo(contentView.snp.centerY)
            make.leading.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        contentView.addSubview(removeButton)
        removeButton.snp.makeConstraints { make in
            make.height.width.equalTo(20)
            make.centerY.equalTo(contentView.snp.centerY)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        contentView.addSubview(searchTitleLabel)
        searchTitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.height.equalTo(20)
            make.leading.equalTo(clockIconButton.snp.trailing).offset(10)
            make.trailing.equalTo(removeButton.snp.leading).offset(-10)
        }
    }
    
    //MARK: - Functions
    
    @objc private func removeButtonTapped() {
        self.delegate?.removeButtonTapped(cell: self)
    }
}
