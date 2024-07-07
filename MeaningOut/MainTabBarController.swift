//
//  TabBarController.swift
//  MeaningOut
//
//  Created by 권대윤 on 6/14/24.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }

    private func setupTabBar() {
        let mainVC = UINavigationController(rootViewController: MainViewController())
        let likeVC = UINavigationController(rootViewController: LikeViewController())
        let settingVC = UINavigationController(rootViewController: SettingViewController())
        
        mainVC.tabBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), tag: 0)
        likeVC.tabBarItem = UITabBarItem(title: "좋아요", image: UIImage(systemName: "heart"), tag: 1)
        settingVC.tabBarItem = UITabBarItem(title: "설정", image: UIImage(systemName: "person"), tag: 2)
        
        self.tabBar.unselectedItemTintColor = Constant.Color.primaryGray
        self.tabBar.tintColor = Constant.Color.signatureColor
        
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = Constant.Color.primaryWhite
        self.tabBar.standardAppearance = appearance
        self.tabBar.scrollEdgeAppearance = appearance
        
        self.setViewControllers([mainVC, likeVC, settingVC], animated: true)
    }
}
