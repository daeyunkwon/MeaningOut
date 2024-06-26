//
//  ProductDetailViewController.swift
//  MeaningOut
//
//  Created by 권대윤 on 6/15/24.
//

import UIKit
import WebKit

import SnapKit

final class ProductDetailViewController: BaseViewController {
    
    //MARK: - Properties
    
    var shoppingItem: ShoppingItem?
    
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
        guard let dictionary = UserDefaultsManager.shared.like else { return }
        guard let productId = shoppingItem?.productId else { return }
        
        if dictionary[productId] != nil {
            self.rightBarButton.image = UIImage(named: "like_selected")?.withRenderingMode(.alwaysOriginal)
        } else {
            self.rightBarButton.image = UIImage(named: "like_unselected")?.withRenderingMode(.alwaysOriginal)
        }
    }
    
    @objc private func rightBarButtonTapped() {
        guard let productId = shoppingItem?.productId else { return }
        
        if UserDefaultsManager.shared.like != nil {
            if UserDefaultsManager.shared.like?[productId] != nil {
                UserDefaultsManager.shared.like?.removeValue(forKey: productId)
            } else {
                UserDefaultsManager.shared.like?[productId] = true
            }
        } else {
            let dict: [String: Bool] = [productId: true]
            UserDefaultsManager.shared.like = dict
        }
        
        self.checkLikeButton()
    }
}
