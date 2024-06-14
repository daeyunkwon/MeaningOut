//
//  ProfileImageSettingViewController.swift
//  MeaningOut
//
//  Created by 권대윤 on 6/14/24.
//

import UIKit

import SnapKit

final class ProfileImageSettingViewController: UIViewController {
    
    //MARK: - Properties
    
    var selectedProfileImage: UIImage?
    
    
    //MARK: - UI Components
    
    private let mainProfileImageView: ProfileCircleWithCameraIcon = {
        let view = ProfileCircleWithCameraIcon()
        return view
    }()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavi()
        configureLayout()
        configureUI()
    }
    
    private func setupNavi() {
        navigationItem.title = "PROFILE SETTING"
    }
    
    private func configureLayout() {
        view.addSubview(mainProfileImageView)
        mainProfileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(5)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
        }
        
        
    }
    
    private func configureUI() {
        view.backgroundColor = Constant.Color.primaryWhite
        mainProfileImageView.profileImageView.image = self.selectedProfileImage
    }
    
    
    //MARK: - Functions
    

}
