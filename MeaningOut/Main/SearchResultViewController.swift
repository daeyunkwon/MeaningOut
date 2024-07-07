//
//  SearchResultViewController.swift
//  MeaningOut
//
//  Created by 권대윤 on 6/15/24.
//

import UIKit

import SnapKit

final class SearchResultViewController: BaseViewController {
    
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
    
    var total: Double = 0
    var buffer = Data() {
        didSet {
            let result = Double(buffer.count) / total
            
            let percentage = result * 100
            
            if result * 100 >= 100 {
                progressLabel.text = "\(total)/\(total) 100%"
            } else {
                progressLabel.text = "\(percentage)/\(total) \(percentage.rounded())%"
            }
        }
    }
    
    let repository = ProductRepository()
    
    //MARK: - UI Components
    
    private let resultCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .heavy)
        label.textColor = Constant.Color.signatureColor
        return label
    }()
    
    private let capsuleAccuracyButton = CapsuleButton(title: "정확도", tag: 0)
    private let capsuleDateButton = CapsuleButton(title: "날짜순", tag: 1)
    private let capsuleRowPriceButton = CapsuleButton(title: "가격낮은순", tag: 2)
    private let capsuleHighPriceButton = CapsuleButton(title: "가격높은순", tag: 3)
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    private let progressLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        label.textAlignment = .center
        return label
    }()
    
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
            self.showNetworkConnectFailAlert(type: .networkConnectFail) { _ in
                self.popViewController()
            }
        }
        
        setupCollectionView()
        
//        NetworkManager.shared.fetchData(api: .shopping(query: self.searchKeyword ?? "", sort: self.sortType.rawValue, start: self.start), model: Shopping.self) { result in
//            switch result {
//            case .success(let data):
//                self.totalCount = data.total ?? 0
//                self.resultCountLabel.text = "\(self.totalCount.formatted())개의 검색 결과"
//                if self.page == 1 {
//                    self.list = data.items
//                } else {
//                    self.list.append(contentsOf: data.items)
//                }
//                self.collectionView.reloadData()
//            
//            case .failure(let error):
//                self.showNetworkConnectFailAlert(type: .networkConnectFail) { _ in
//                    print(error)
//                    self.popViewController()
//                }
//            }
//        }
        
        NetworkManager.shared.fetchDataUsingURLSessionDelegate(api: .shopping(query: self.searchKeyword ?? "", sort: self.sortType.rawValue, start: self.start), delegate: self)
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
        collectionView.prefetchDataSource = self
    }
    
    override func configureLayout() {
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
        
        view.addSubview(progressLabel)
        progressLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override func configureUI() {
        super.configureUI()
        [capsuleAccuracyButton, capsuleDateButton, capsuleHighPriceButton, capsuleRowPriceButton].forEach {
            $0.addTarget(self, action: #selector(capsuleOptionButtonTapped), for: .touchUpInside)
        }
        self.checkStatusCapsuleOptionButton()
        self.progressLabel.isHidden = true
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
    
    private func fetchData(sender: UIButton) {
        if NetworkCheckManager.shared.isConnected {
            executeFetchShopping(sender: sender)
        } else {
            self.showNetworkConnectFailAlert(type: .networkConnectFail) { _ in
                sender.isUserInteractionEnabled = true
                if NetworkCheckManager.shared.isConnected {
                    self.executeFetchShopping(sender: sender)
                }
            }
        }
    }
    
    private func executeFetchShopping(sender: UIButton) {
//        NetworkManager.shared.fetchData(api: .shopping(query: searchKeyword ?? "", sort: self.sortType.rawValue, start: self.start), model: Shopping.self) { result in
//            switch result {
//            case .success(let data):
//                self.totalCount = data.total ?? 0
//                self.resultCountLabel.text = "\(self.totalCount.formatted())개의 검색 결과"
//                if self.page == 1 {
//                    self.list = data.items
//                } else {
//                    self.list.append(contentsOf: data.items)
//                }
//                self.collectionView.reloadData()
//                sender.isUserInteractionEnabled = true
//                self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true)
//            
//            case .failure(let error):
//                self.showNetworkConnectFailAlert(type: .networkConnectFail) { _ in
//                    print(error)
//                }
//            }
//        }
        
        NetworkManager.shared.fetchDataUsingURLSessionDelegate(api: .shopping(query: self.searchKeyword ?? "", sort: self.sortType.rawValue, start: self.start), delegate: self)
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
    
    @objc private func capsuleOptionButtonTapped(sender: UIButton) {
        
        var currtenType: Int //현재 선택된 옵션 버튼
        
        switch self.sortType {
        case .sim:
            currtenType = 0
        case .date:
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
        
        sender.isUserInteractionEnabled = false //네트워크 통신 작업이 끝나기 전까지 버튼 동작 비활성화
        
        switch sender.tag {
        case 0: self.sortType = .sim
        case 1: self.sortType = .date
        case 2: self.sortType = .asc
        case 3: self.sortType = .dsc
        default: break
        }
        self.checkStatusCapsuleOptionButton()
        
        self.page = 1
        
        fetchData(sender: sender)
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as? SearchResultCollectionViewCell else {
            print("Failed to dequeue a SearchResultCollectionViewCell. Using default UICollectionViewCell.")
            return UICollectionViewCell()
        }
        cell.delegate = self
        cell.searchKeyword = self.searchKeyword
        cell.viewType = .searchResult
        cell.shoppingItem = list[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ProductDetailViewController()
        vc.shoppingItem = self.list[indexPath.row]
        pushViewController(vc)
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
                    fetchData()
                }
            }
        }
    }
    
    private func fetchData() {
        if NetworkCheckManager.shared.isConnected {
            executeFetchShopping()
        } else {
            self.showNetworkConnectFailAlert(type: .networkConnectFail) { _ in
                if NetworkCheckManager.shared.isConnected {
                    self.executeFetchShopping()
                }
            }
        }
    }
    
    private func executeFetchShopping() {
//        NetworkManager.shared.fetchData(api: .shopping(query: self.searchKeyword ?? "", sort: self.sortType.rawValue, start: self.start), model: Shopping.self) { result in
//            switch result {
//            case .success(let data):
//                self.totalCount = data.total ?? 0
//                self.resultCountLabel.text = "\(self.totalCount.formatted())개의 검색 결과"
//                if self.page == 1 {
//                    self.list = data.items
//                } else {
//                    self.list.append(contentsOf: data.items)
//                }
//                self.collectionView.reloadData()
//            
//            case .failure(let error):
//                self.showNetworkConnectFailAlert(type: .networkConnectFail) { _ in
//                    print(error)
//                }
//            }
//        }
        NetworkManager.shared.fetchDataUsingURLSessionDelegate(api: .shopping(query: self.searchKeyword ?? "", sort: self.sortType.rawValue, start: self.start), delegate: self)
    }
}

//MARK: - SearchResultCollectionViewCellDelegate

extension SearchResultViewController: SearchResultCollectionViewCellDelegate {
    func likeButtonTapped(cell: SearchResultCollectionViewCell) {
        guard let productId = cell.shoppingItem?.productId else { return }
        
        if repository.isItemSaved(productID: productId) {
            //저장되어 있는 경우
            if let product = repository.fetchItem(productID: productId) {
                ImageFileManager.shared.removeImageFromDocument(filename: product.imageID)
                repository.deleteItem(data: product)
            }
            
        } else {
            //저장 안된 경우
            guard let item = cell.shoppingItem else { return }
            guard let mallName = item.mallName else { return }
            let lprice = Int(item.lprice ?? "")
            let hprice = Int(item.hprice ?? "")
            
            let data = Product(title: item.titleString, mallName: mallName, link: item.linkURL, lprice: lprice, hprice: hprice, productID: productId)
            repository.createItem(data: data)
            if let image = cell.productImage.image {
                ImageFileManager.shared.saveImageToDocument(image: image, filename: data.imageID)
            }
        }
        
        cell.checkLikeButton()
    }
}

//MARK: - URLSessionDataDelegate

extension SearchResultViewController: URLSessionDataDelegate {
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse) async -> URLSession.ResponseDisposition {
        if let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) {
            let contentLength = response.value(forHTTPHeaderField: "Content-Length") ?? ""
            [capsuleDateButton, capsuleAccuracyButton, capsuleRowPriceButton, capsuleHighPriceButton].forEach {
                $0.isUserInteractionEnabled = false
            }
            self.progressLabel.isHidden = false
            self.total = Double(contentLength) ?? 0
            self.buffer = Data()
            
            return .allow
        } else {
            return .cancel
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        self.buffer.append(data)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: (any Error)?) {
        if let error = error {
            self.showNetworkConnectFailAlert(type: .networkConnectFail) { _ in
                print(error)
                if self.page == 1 {
                    self.popViewController()
                }
            }
            return
        }
        
        do {
            let data = try JSONDecoder().decode(Shopping.self, from: buffer)
            self.totalCount = data.total ?? 0
            self.resultCountLabel.text = "\(self.totalCount.formatted())개의 검색 결과"
            if self.page == 1 {
                self.list = data.items
            } else {
                self.list.append(contentsOf: data.items)
            }
            self.collectionView.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.progressLabel.isHidden = true
                [self.capsuleDateButton, self.capsuleAccuracyButton, self.capsuleRowPriceButton, self.capsuleHighPriceButton].forEach {
                    $0.isUserInteractionEnabled = true
                }
            }
        } catch {
            self.showNetworkConnectFailAlert(type: .networkConnectFail) { _ in
                
            }
        }
    }
}
