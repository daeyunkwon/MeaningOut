//
//  ProductDetailViewController.swift
//  MeaningOut
//
//  Created by 권대윤 on 6/15/24.
//

import UIKit
import WebKit

import Kingfisher
import SnapKit

final class ProductDetailViewController: BaseViewController {
    
    //MARK: - Properties
    
    var shoppingItem: ShoppingItem?
    var product: Product?
    var backupProduct: Product?
    
    let repository = ProductRepository()
    
    var itemTitle: String?
    var linkURL: String?
    var productID: String?
    
    enum ViewType {
        case fromSearchResultVC
        case fromLikeVC
    }
    var viewType: ViewType = .fromSearchResultVC
    
    //MARK: - UI Components
    
    private let webView = WKWebView()
    
    private lazy var rightBarButton = UIBarButtonItem(image: UIImage(named: "like_unselected")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(rightBarButtonTapped))
    
    //MARK: - Life Cycle
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        if !NetworkCheckManager.shared.isConnected {
            self.showNetworkConnectFailAlert(type: .networkConnectFail) { _ in
                self.popViewController()
            }
        }
        
        configureUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavi()
        self.backupProduct = Product(value: self.product ?? Product())
    }
    
    private func setupNavi() {
        guard let title = self.itemTitle else { return }
        navigationItem.title = title
        
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    override func configureLayout() {
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        super.configureUI()
        guard let productURL = self.linkURL else { return }
        guard let url = URL(string: productURL) else {
            self.showNetworkConnectFailAlert(type: .urlInvalid) { _ in
                self.popViewController()
            }
            return
        }
        
        webView.load(URLRequest(url: url))
        self.checkLikeButton()
    }
    
    //MARK: - Functions
    
    private func checkLikeButton() {
        guard let productId = self.productID else { return }
        
        if repository.isItemSaved(productID: productId) {
            self.rightBarButton.image = UIImage(named: "like_selected")?.withRenderingMode(.alwaysOriginal)
        } else {
            self.rightBarButton.image = UIImage(named: "like_unselected")?.withRenderingMode(.alwaysOriginal)
        }
    }
    
    @objc private func rightBarButtonTapped() {
        guard let productId = self.productID else { return }
        
        if repository.isItemSaved(productID: productId) {
            
            switch viewType {
            case .fromSearchResultVC:
                //Realm에서 저장되어 있는 레코드 삭제
                if let product = repository.fetchItem(productID: productId) {
                    ImageFileManager.shared.removeImageFromDocument(filename: product.imageID)
                    repository.deleteItem(data: product)
                }
            
            case .fromLikeVC:
                //Realm에서 저장되어 있는 레코드 삭제
                if let product = repository.fetchItem(productID: backupProduct?.productID ?? "") {
                    ImageFileManager.shared.removeImageFromDocument(filename: product.imageID)
                    repository.deleteItem(data: product)
                }
            }
        } else {
            
            switch viewType {
            case .fromSearchResultVC:
                //Realm에 새로운 레코드 생성
                guard let item = shoppingItem else { return }
                guard let mallName = item.mallName else { return }
                let lprice = Int(item.lprice ?? "")
                let hprice = Int(item.hprice ?? "")
                
                let data = Product(title: item.titleString, mallName: mallName, link: item.linkURL, lprice: lprice, hprice: hprice, productID: productId, imageURL: item.imageURL)
                repository.createItem(data: data)
                
                
                ImageDownloader.default.downloadImage(with: URL(string: item.imageURL) ?? URL(fileURLWithPath: ""), options: [.transition(.fade(1))]) { result in
                    switch result {
                    case .success(let imageResult):
                        
                        let image = imageResult.image
                        ImageFileManager.shared.saveImageToDocument(image: image, filename: data.imageID)
                        
                    case .failure(let error):
                        print("Image download failed: \(error.localizedDescription)")
                    }
                }
                
            case .fromLikeVC:
                //Realm에 새로운 레코드 생성
                guard let item = backupProduct else { return }
                
                let data = Product(title: item.title, mallName: item.mallName, link: item.link, lprice: item.lprice, hprice: item.hprice, productID: item.productID, imageURL: item.imageURL)
                
                
                repository.createItem(data: data)
                
                
                ImageDownloader.default.downloadImage(with: URL(string: item.imageURL) ?? URL(fileURLWithPath: ""), options: [.transition(.fade(1))]) { result in
                    switch result {
                    case .success(let imageResult):
                        
                        let image = imageResult.image
                        ImageFileManager.shared.saveImageToDocument(image: image, filename: data.imageID)
                        
                    case .failure(let error):
                        print("Image download failed: \(error.localizedDescription)")
                    }
                }
            }
        }
        self.checkLikeButton()
    }
    
    
}

