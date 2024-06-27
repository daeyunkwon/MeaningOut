//
//  SearchResultCollectionViewCell.swift
//  MeaningOut
//
//  Created by 권대윤 on 6/15/24.
//

import UIKit

import Kingfisher
import SkeletonView
import SnapKit

final class SearchResultCollectionViewCell: BaseCollectionViewCell {
    
    //MARK: - Properties
    
    var searchKeyword: String?
    
    var shoppingItem: ShoppingItem? {
        didSet {
            guard let data = shoppingItem else {return}
            productImage.showAnimatedGradientSkeleton()
            productImage.kf.setImage(with: URL(string: data.imageURL), completionHandler: { result in
                switch result {
                case .success(_):
                    self.productImage.hideSkeleton()
                case .failure(let error):
                    print(error)
                    break
                }
            })
            
            mallName.text = data.mallName
            price.text = data.priceString + "원"
            highlightSearchKeyword(keyword: self.searchKeyword, title: data.titleString)
            
            checkLikeButton()
        }
    }
    
    weak var delegate: SearchResultCollectionViewCellDelegate?
    
    //MARK: - UI Components
    
    private let productImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 10
        iv.backgroundColor = Constant.Color.primaryLightGray
        iv.clipsToBounds = true
        iv.isSkeletonable = true
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
    
    override func configureLayout() {
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
    
    @objc private func likeButtonTapped() {
        self.delegate?.likeButtonTapped(cell: self)
    }
    
    func checkLikeButton() {
        guard let dictionary = UserDefaultsManager.shared.like else {return}
        guard let productId = shoppingItem?.productId else {return}
        if dictionary[productId] != nil {
            backView.backgroundColor = Constant.Color.primaryWhite
            backView.alpha = 1
            likeButton.setImage(UIImage(named: "like_selected")?.withRenderingMode(.alwaysOriginal), for: .normal)
        } else {
            backView.backgroundColor = Constant.Color.primaryGray
            backView.alpha = 0.5
            likeButton.setImage(UIImage(named: "like_unselected")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    private func highlightSearchKeyword(keyword: String?, title: String?) {
        guard let keyword = keyword else {return}
        guard let title = title else {return}
        
        let attributed = NSMutableAttributedString(string: title, attributes: [.font: Constant.Font.system14, .foregroundColor: Constant.Color.primaryBlack])
        let range = NSString(string: title).range(of: keyword.trimmingCharacters(in: .whitespaces))
        attributed.addAttributes([.foregroundColor: Constant.Color.signatureColor, .font: Constant.Font.system14], range: range)
        
        self.productTitle.attributedText = attributed
    }
}
