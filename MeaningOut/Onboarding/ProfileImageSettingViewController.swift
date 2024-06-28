//
//  ProfileImageSettingViewController.swift
//  MeaningOut
//
//  Created by 권대윤 on 6/14/24.
//

import UIKit

import SnapKit

final class ProfileImageSettingViewController: BaseViewController {
    
    //MARK: - Properties
    
    var selectedProfileImage: UIImage?
    
    var selectedProfileImageSend: ((UIImage?) -> Void) = {sender in}
    
    enum ViewType {
        case profileSetting
        case editProfile
    }
    var viewType: ViewType = .profileSetting
    
    //MARK: - UI Components
    
    private let mainProfileImageView: ProfileCircleWithCameraIcon = {
        let view = ProfileCircleWithCameraIcon()
        return view
    }()
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionView.layoutSquareType(sectionSpacing: 20, minimumInteritemSpacing: 10, minimumLineSpacing: 10, cellCount: 4))
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavi()
        setupCollectionView()
    }
    
    private func setupNavi() {
        switch viewType {
        case .profileSetting:
            navigationItem.title = "PROFILE SETTING"
        case .editProfile:
            navigationItem.title = "EDIT PROFILE"
        }
    }
    
    private func setupCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(ProfileImageCollectionViewCell.self, forCellWithReuseIdentifier: ProfileImageCollectionViewCell.identifier)
    }
    
    override func configureLayout() {
        view.addSubview(mainProfileImageView)
        mainProfileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(mainProfileImageView.snp.bottom).offset(50)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        super.configureUI()
        mainProfileImageView.profileImageView.image = self.selectedProfileImage
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension ProfileImageSettingViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constant.ProfileImage.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageCollectionViewCell.identifier, for: indexPath) as? ProfileImageCollectionViewCell else {
            print("Failed to dequeue a ProfileImageCollectionViewCell. Using default UICollectionViewCell.")
            return UICollectionViewCell()
        }
        
        let image = UIImage(named: Constant.ProfileImage.allCases[indexPath.row].rawValue)
        
        
        if self.selectedProfileImage == image {
            cell.type = .selected
        } else {
            cell.type = .unselected
        }
        
        cell.profile = image
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedProfileImage = UIImage(named: Constant.ProfileImage.allCases[indexPath.row].rawValue)
        mainProfileImageView.profileImageView.image = selectedProfileImage
        collectionView.reloadData()
        
        self.selectedProfileImageSend(selectedProfileImage) //이전 화면에 선택된 이미지 데이터 전달
    }
}


