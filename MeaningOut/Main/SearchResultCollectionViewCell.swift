//
//  SearchResultCollectionViewCell.swift
//  MeaningOut
//
//  Created by 권대윤 on 6/15/24.
//

import UIKit

import SnapKit

final class SearchResultCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    
    //MARK: - UI Components
    
    private let productImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 10
        iv.backgroundColor = Constant.Color.primaryLightGray
        return iv
    }()
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = Constant.Color.primaryGray
        view.alpha = 0.5
        view.layer.cornerRadius = 5
        return view
    }()
    
    private lazy var likeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "like_unselected")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    private let mallName: UILabel = {
        let label = UILabel()
        label.textColor = Constant.Color.primaryLightGray
        label.font = Constant.Font.system13
        return label
    }()
    
    private let productTitle: UILabel = {
        let label = UILabel()
        label.textColor = Constant.Color.primaryBlack
        label.font = Constant.Font.system15
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    
    private let price: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constant.Font.system16.pointSize, weight: .heavy)
        return label
    }()
    
    //MARK: - Life Cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImage.image = nil
        mallName.text = ""
        productTitle.text = ""
        price.text = ""
        likeButton.setImage(UIImage(named: "like_unselected")?.withRenderingMode(.alwaysOriginal), for: .normal)
        backView.backgroundColor = Constant.Color.primaryGray
        backView.alpha = 0.5
    }

    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        contentView.backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        contentView.addSubview(productImage)
        productImage.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(contentView.safeAreaLayoutGuide)
            make.height.equalTo(200)
        }
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints { make in
            make.trailing.equalTo(productImage.snp.trailing).offset(-10)
            make.bottom.equalTo(productImage.snp.bottom).offset(-10)
            make.width.height.equalTo(30)
        }
        
        backView.addSubview(likeButton)
        likeButton.snp.makeConstraints { make in
            make.verticalEdges.horizontalEdges.equalToSuperview().inset(5)
        }
        
        contentView.addSubview(mallName)
        mallName.snp.makeConstraints { make in
            make.top.equalTo(productImage.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.height.equalTo(10)
        }
        
        contentView.addSubview(productTitle)
        productTitle.snp.makeConstraints { make in
            make.top.equalTo(mallName.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        contentView.addSubview(price)
        price.snp.makeConstraints { make in
            make.top.equalTo(productTitle.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    
    
    
    //MARK: - Fuctions
    
    @objc func likeButtonTapped() {
        print(#function)
    }
    
}
