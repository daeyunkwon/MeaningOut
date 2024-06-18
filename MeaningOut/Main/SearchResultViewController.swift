//
//  SearchResultViewController.swift
//  MeaningOut
//
//  Created by 권대윤 on 6/15/24.
//

import UIKit

import Alamofire
import SnapKit

final class SearchResultViewController: UIViewController {
    
    //MARK: - Properties
    
    var searchKeyword: String?
    
    private var list: [ShoppingItem] = []
    
    private var totalCount = 0
    private var page = 1
    
    private var start: Int {
        get {
            return 1 + (page * 30) - 30
        }
    }
    
    private enum SortType: String {
        case sim
        case date
        case asc
        case dsc
    }
    private var sortType: SortType = .sim
    
    //MARK: - UI Components
    
    private let resultCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .heavy)
        label.textColor = Constant.Color.primaryOrange
        return label
    }()
    
    private let capsuleAccuracyButton = CapsuleButton(title: "정확도", tag: 0)
    private let capsuleDateButton = CapsuleButton(title: "날짜순", tag: 1)
    private let capsuleRowPriceButton = CapsuleButton(title: "가격낮은순", tag: 2)
    private let capsuleHighPriceButton = CapsuleButton(title: "가격높은순", tag: 3)
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    //MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = self.searchKeyword
        self.collectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.title = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !NetworkCheckManager.shared.isConnected { //네트워크 미연결 상태일 경우
            self.showNetworkConnectFailAlert()
        }
        setupCollectionView()
        configureLayout()
        configureUI()
        callRequest(query: searchKeyword ?? "", sort: self.sortType.rawValue)
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
        collectionView.prefetchDataSource = self
    }
    
    private func configureLayout() {
        view.addSubview(resultCountLabel)
        resultCountLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        view.addSubview(capsuleAccuracyButton)
        capsuleAccuracyButton.snp.makeConstraints { make in
            make.top.equalTo(resultCountLabel.snp.bottom).offset(15)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.width.equalTo(60)
            make.height.equalTo(35)
        }
        
        view.addSubview(capsuleDateButton)
        capsuleDateButton.snp.makeConstraints { make in
            make.top.equalTo(capsuleAccuracyButton.snp.top)
            make.leading.equalTo(capsuleAccuracyButton.snp.trailing).offset(5)
            make.width.equalTo(60)
            make.height.equalTo(35)
        }
        
        view.addSubview(capsuleHighPriceButton)
        capsuleHighPriceButton.snp.makeConstraints { make in
            make.top.equalTo(capsuleDateButton.snp.top)
            make.leading.equalTo(capsuleDateButton.snp.trailing).offset(5)
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
            make.top.equalTo(capsuleAccuracyButton.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureUI() {
        view.backgroundColor = Constant.Color.primaryWhite
        [capsuleAccuracyButton, capsuleDateButton, capsuleHighPriceButton, capsuleRowPriceButton].forEach {
            $0.layoutIfNeeded()
            $0.addTarget(self, action: #selector(capsuleOptionButtonTapped), for: .touchUpInside)
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
    
    private func callRequest(query: String, sort: String) {
        let param: Parameters = [
            "query": query,
            "display": 30,
            "sort": sort,
            "start": self.start
        ]
        
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.clientId,
            "X-Naver-Client-Secret": APIKey.clientSecret
        ]
        
        AF.request(APIURL.naverShoppingURL, parameters: param, encoding: URLEncoding.queryString, headers: header).responseDecodable(of: Shopping.self) { response in
            switch response.result {
            case .success(let data):
                self.totalCount = data.total ?? 0
                self.resultCountLabel.text = "\(self.totalCount.formatted())개의 검색 결과"
                if self.page == 1 {
                    self.list = data.items
                } else {
                    self.list.append(contentsOf: data.items)
                }
                self.collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func checkStatusCapsuleOptionButton() {
        switch sortType {
        case .sim:
            updateUICapsuleOptionButton(selected: capsuleAccuracyButton)
        case .date:
            updateUICapsuleOptionButton(selected: capsuleDateButton)
        case .asc:
            updateUICapsuleOptionButton(selected: capsuleRowPriceButton)
        case .dsc:
            updateUICapsuleOptionButton(selected: capsuleHighPriceButton)
        }
    }
    
    private func updateUICapsuleOptionButton(selected button: UIButton) {
        [capsuleAccuracyButton, capsuleDateButton, capsuleHighPriceButton, capsuleRowPriceButton].forEach {
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
    
    @objc func capsuleOptionButtonTapped(sender: UIButton) {
        switch sender.tag {
        case 0: self.sortType = .sim
        case 1: self.sortType = .date
        case 2: self.sortType = .asc
        case 3: self.sortType = .dsc
        default: break
        }
        self.checkStatusCapsuleOptionButton()
        
        self.page = 1
        callRequest(query: self.searchKeyword ?? "", sort: self.sortType.rawValue)
        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true)
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as! SearchResultCollectionViewCell
        cell.delegate = self
        cell.searchKeyword = self.searchKeyword
        cell.shoppingItem = list[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ProductDetailViewController()
        vc.shoppingItem = self.list[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - UICollectionViewDataSourcePrefetching

extension SearchResultViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        //print("실행전: \(indexPaths), 지금까지의 셀 개수: \(list.count), 토탈: \(totalCount) ")
        
        for item in indexPaths {
            if item.row >= self.list.count - 1 {
                if item.row < self.totalCount && list.count < totalCount {
                    self.page += 1
                    self.callRequest(query: self.searchKeyword ?? "", sort: self.sortType.rawValue)
                }
            }
        }
    }
}

//MARK: - SearchResultCollectionViewCellDelegate

extension SearchResultViewController: SearchResultCollectionViewCellDelegate {
    func likeButtonTapped(cell: SearchResultCollectionViewCell) {
        guard let productId = cell.shoppingItem?.productId else {return}
        
        if UserDefaultsManager.shared.like != nil {
            if UserDefaultsManager.shared.like?[productId] != nil {
                UserDefaultsManager.shared.like?.removeValue(forKey: productId)
            } else {
                UserDefaultsManager.shared.like?[productId] = true
            }
        } else {
            let dict: [String: Any] = [productId: true]
            UserDefaultsManager.shared.like = dict
        }
        
        cell.checkLikeButton()
    }
}
