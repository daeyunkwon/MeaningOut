//
//  SearchResultCollectionViewCell.swift
//  MeaningOut
//
//  Created by 권대윤 on 6/15/24.
//

import UIKit

import Kingfisher
import SnapKit

final class SearchResultCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    var shoppingItem: ShoppingItem? {
        didSet {
            guard let data = shoppingItem else {return}
            
            productImage.kf.setImage(with: URL(string: data.imageURL))
            mallName.text = data.mallName
            productTitle.text = data.titleString
            price.text = data.priceString + "원"
        }
    }
    
    //MARK: - UI Components
    
    private let productImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 10
        iv.backgroundColor = Constant.Color.primaryLightGray
        iv.clipsToBounds = true
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
        label.textColor = Constant.Color.primaryGray
        label.font = Constant.Font.system13
        return label
    }()
    
    private let productTitle: UILabel = {
        let label = UILabel()
        label.textColor = Constant.Color.primaryBlack
        label.font = Constant.Font.system14
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
        
        contentView.addSubview(likeButton)
        likeButton.snp.makeConstraints { make in
            make.edges.equalTo(backView.snp.edges)
        }
        
        contentView.addSubview(mallName)
        mallName.snp.makeConstraints { make in
            make.top.equalTo(productImage.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.height.equalTo(13)
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
