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
    
    let repository = ProductRepository()
    
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
    }
    
    private func setupNavi() {
        guard let title = self.shoppingItem?.titleString else { return }
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
        guard let productURL = self.shoppingItem?.linkURL else { return }
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
        
        guard let productId = shoppingItem?.productId else { return }
        
        if repository.isItemSaved(productID: productId) {
            self.rightBarButton.image = UIImage(named: "like_selected")?.withRenderingMode(.alwaysOriginal)
        } else {
            self.rightBarButton.image = UIImage(named: "like_unselected")?.withRenderingMode(.alwaysOriginal)
        }
    }
    
    @objc private func rightBarButtonTapped() {
        guard let productId = shoppingItem?.productId else { return }
        
        if repository.isItemSaved(productID: productId) {
            //저장되어 있는 경우
            if let product = repository.fetchItem(productID: productId) {
                ImageFileManager.shared.removeImageFromDocument(filename: product.imageID)
                repository.deleteItem(data: product)
            }
            
        } else {
            //저장 안된 경우
            guard let item = shoppingItem else { return }
            guard let mallName = item.mallName else { return }
            let lprice = Int(item.lprice ?? "")
            let hprice = Int(item.hprice ?? "")
            
            let data = Product(title: item.titleString, mallName: mallName, link: item.linkURL, lprice: lprice, hprice: hprice, productID: productId)
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
        
        self.checkLikeButton()
    }
}

