//
//  LikeViewController.swift
//  MeaningOut
//
//  Created by 권대윤 on 7/7/24.
//

import UIKit

import RealmSwift
import SnapKit

final class LikeViewController: BaseViewController {
    
    //MARK: - Properties
    
    private enum SortType: String {
        case date
        case name
        case asc
        case dsc
    }
    private var sortType: SortType = .date
    
    private var products: [Product] = [] {
        didSet {
            if products.isEmpty {
                self.viewDisplayType = .empty
            } else {
                self.viewDisplayType = .nonEmpty
            }
            self.collectionView.reloadData()
            resultCountLabel.text = "전체 \(self.products.count)개"
        }
    }
    
    private let repository = ProductRepository()
    
    private enum ViewDisplayType {
        case empty
        case nonEmpty
    }
    private var viewDisplayType: ViewDisplayType = .nonEmpty {
        didSet {
            self.updateDisplayWithRecentSearch()
        }
    }
    
    //MARK: - UI Components
    
    private let resultCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .heavy)
        label.textColor = Constant.Color.signatureColor
        return label
    }()
    
    private let capsuleDateButton = CapsuleButton(title: "담은순", tag: 0)
    private let capsuleNameButton = CapsuleButton(title: "이름순", tag: 1)
    private let capsuleRowPriceButton = CapsuleButton(title: "가격낮은순", tag: 2)
    private let capsuleHighPriceButton = CapsuleButton(title: "가격높은순", tag: 3)
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    private let emptyRecentSearchImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "empty")
        return iv
    }()
    
    private let emptyRecentSearchLabel: UILabel = {
        let label = UILabel()
        label.text = "관심있는 상품이 없어요"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .heavy)
        return label
    }()
    
    //MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "좋아요"
        products = Array(repository.fetchAllItem())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.title = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
    }
    
    override func configureLayout() {
        view.addSubview(emptyRecentSearchImageView)
        emptyRecentSearchImageView.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.centerY.equalTo(view.safeAreaLayoutGuide).offset(-24)
            make.width.equalTo(view.safeAreaLayoutGuide).inset(70)
            make.height.equalTo(emptyRecentSearchImageView.snp.width)
        }
        
        view.addSubview(emptyRecentSearchLabel)
        emptyRecentSearchLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyRecentSearchImageView.snp.bottom).offset(5)
            make.centerX.equalTo(emptyRecentSearchImageView.snp.centerX)
            make.height.equalTo(30)
        }
        
        view.addSubview(resultCountLabel)
        resultCountLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        view.addSubview(capsuleDateButton)
        capsuleDateButton.snp.makeConstraints { make in
            make.top.equalTo(resultCountLabel.snp.bottom).offset(15)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.width.equalTo(60)
            make.height.equalTo(35)
        }
        
        view.addSubview(capsuleNameButton)
        capsuleNameButton.snp.makeConstraints { make in
            make.top.equalTo(capsuleDateButton.snp.top)
            make.leading.equalTo(capsuleDateButton.snp.trailing).offset(5)
            make.width.equalTo(60)
            make.height.equalTo(35)
        }
        
        view.addSubview(capsuleHighPriceButton)
        capsuleHighPriceButton.snp.makeConstraints { make in
            make.top.equalTo(capsuleNameButton.snp.top)
            make.leading.equalTo(capsuleNameButton.snp.trailing).offset(5)
            make.width.equalTo(80)
            make.height.equalTo(35)
        }
        
        view.addSubview(capsuleRowPriceButton)
        capsuleRowPriceButton.snp.makeConstraints { make in
            make.top.equalTo(capsuleHighPriceButton.snp.top)
            make.leading.equalTo(capsuleHighPriceButton.snp.trailing).offset(5)
            make.width.equalTo(80)
            make.height.equalTo(35)
        }
                                
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(capsuleDateButton.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        super.configureUI()
        
        [self.capsuleDateButton, self.capsuleNameButton, self.capsuleHighPriceButton, self.capsuleRowPriceButton].forEach {
            $0.addTarget(self, action: #selector(self.capsuleOptionButtonTapped), for: .touchUpInside)
            $0.layer.cornerRadius = 10
        }
        self.checkStatusCapsuleOptionButton()
    }
    
    static func layout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let cellCount: CGFloat = 2
        let sectionSpacing: CGFloat = 20
        let cellSpacing: CGFloat = 20
        let width = UIScreen.main.bounds.width - ((cellSpacing * (cellCount - 1)) + (sectionSpacing * 2))
        layout.itemSize = CGSize(width: width / cellCount, height: width / cellCount * 1.8)
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        layout.scrollDirection = .vertical
        return layout
    }
    
    //MARK: - Functions
    
    private func checkStatusCapsuleOptionButton() {
        switch sortType {
        case .date:
            updateUICapsuleOptionButton(selected: capsuleDateButton)
        case .name:
            updateUICapsuleOptionButton(selected: capsuleNameButton)
        case .asc:
            updateUICapsuleOptionButton(selected: capsuleRowPriceButton)
        case .dsc:
            updateUICapsuleOptionButton(selected: capsuleHighPriceButton)
        }
    }
    
    private func updateUICapsuleOptionButton(selected button: UIButton) {
        [capsuleDateButton, capsuleNameButton, capsuleHighPriceButton, capsuleRowPriceButton].forEach {
            if $0 == button {
                $0.backgroundColor = Constant.Color.primaryDarkGray
                $0.setTitleColor(Constant.Color.primaryWhite, for: .normal)
                $0.layer.borderColor = Constant.Color.primaryDarkGray.cgColor
            } else {
                $0.backgroundColor = Constant.Color.primaryWhite
                $0.setTitleColor(Constant.Color.primaryBlack, for: .normal)
                $0.layer.borderColor = Constant.Color.primaryLightGray.cgColor
            }
        }
    }
    
    @objc private func capsuleOptionButtonTapped(sender: UIButton) {
        var currtenType: Int //현재 선택된 옵션 버튼 판별용
        
        switch self.sortType {
        case .date:
            currtenType = 0
        case .name:
            currtenType = 1
        case .asc:
            currtenType = 2
        case .dsc:
            currtenType = 3
        }
        
        if sender.tag == currtenType { //이미 선택되어 있는 옵션 버튼을 재선택한 경우
            collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true)
            return
        }
        
        switch sender.tag {
        case 0:
            self.sortType = .date
            products = Array(repository.fetchAllItemSorted(key: .registrationDate, ascending: false))
        
        case 1:
            self.sortType = .name
            products = Array(repository.fetchAllItemSorted(key: .title, ascending: true))
        
        case 2:
            self.sortType = .asc
            products = Array(repository.fetchAllItemSorted(key: .lprice, ascending: true))
        
        case 3:
            self.sortType = .dsc
            products = Array(repository.fetchAllItemSorted(key: .lprice, ascending: false))
        default: break
        }
        
        self.checkStatusCapsuleOptionButton()
    }
    
    private func updateDisplayWithRecentSearch() {
        switch viewDisplayType {
        case .empty:
            displayEmptyView(isShow: true)
        case .nonEmpty:
            displayEmptyView(isShow: false)
        }
    }
    
    private func displayEmptyView(isShow: Bool) {
        if isShow {
            emptyRecentSearchImageView.isHidden = false
            emptyRecentSearchLabel.isHidden = false
            collectionView.isHidden = true
        } else {
            emptyRecentSearchImageView.isHidden = true
            emptyRecentSearchLabel.isHidden = true
            collectionView.isHidden = false
        }
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension LikeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as? SearchResultCollectionViewCell else {
            print("Failed to dequeue a SearchResultCollectionViewCell. Using default UICollectionViewCell.")
            return UICollectionViewCell()
        }
        cell.delegate = self
        cell.viewType = .like
        let data = products[indexPath.row]
        cell.product = data
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ProductDetailViewController()
        vc.product = self.products[indexPath.row]
        vc.linkURL = self.products[indexPath.row].link
        vc.itemTitle = self.products[indexPath.row].title
        vc.productID = self.products[indexPath.row].productID
        vc.viewType = .fromLikeVC
        pushViewController(vc)
    }
}

//MARK: - SearchResultCollectionViewCellDelegate

extension LikeViewController: SearchResultCollectionViewCellDelegate {
    func likeButtonTapped(cell: SearchResultCollectionViewCell) {
        guard let productId = cell.product?.productID else { return }
        
        if repository.isItemSaved(productID: productId) {
            //저장되어 있는 경우
            if let product = repository.fetchItem(productID: productId) {
                ImageFileManager.shared.removeImageFromDocument(filename: product.imageID)
                repository.deleteItem(data: product)
                
                switch sortType {
                case .date:
                    products = Array(repository.fetchAllItemSorted(key: .registrationDate, ascending: false))
                
                case .name:
                    products = Array(repository.fetchAllItemSorted(key: .title, ascending: true))
                
                case .asc:
                    products = Array(repository.fetchAllItemSorted(key: .lprice, ascending: true))
                
                case .dsc:
                    products = Array(repository.fetchAllItemSorted(key: .lprice, ascending: false))
                }
            }
            
        } else {
            //저장 안된 경우
            guard let item = cell.shoppingItem else { return }
            guard let mallName = item.mallName else { return }
            let lprice = Int(item.lprice ?? "")
            let hprice = Int(item.hprice ?? "")
            
            let data = Product(title: item.titleString, mallName: mallName, link: item.linkURL, lprice: lprice, hprice: hprice, productID: productId, imageURL: item.imageURL)
            repository.createItem(data: data)
            if let image = cell.productImage.image {
                ImageFileManager.shared.saveImageToDocument(image: image, filename: data.imageID)
            }
        }
    }
}
