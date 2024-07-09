//
//  ViewController.swift
//  MeaningOut
//
//  Created by 권대윤 on 6/13/24.
//

import UIKit

import SnapKit

final class ProfileSettingViewController: BaseViewController {
    
    //MARK: - Properties
    
    let viewModel = ProfileSettingViewModel()
    
    var profileImage: UIImage?
    
    enum ViewType {
        case profileSetting
        case editProfile
    }
    var viewType: ViewType = .profileSetting
    
    //MARK: - UI Components
    
    private lazy var profileCircleWithCameraIconView: ProfileCircleWithCameraIcon = {
        let view = ProfileCircleWithCameraIcon()
        let tap = UITapGestureRecognizer(target: self, action: #selector(profileImageViewTapped))
        view.profileImageView.addGestureRecognizer(tap)
        view.profileImageView.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var nicknameTextField: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "닉네임을 입력해주세요 :)", attributes: [.foregroundColor: Constant.Color.primaryGray, .font: Constant.Font.system15])
        tf.backgroundColor = .clear
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.keyboardType = .default
        tf.returnKeyType = .done
        tf.delegate = self
        return tf
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = Constant.Color.primaryLightGray
        return view
    }()
    
    private let nicknameConditionLabel: UILabel = {
        let label = UILabel()
        label.font = Constant.Font.system13
        label.textColor = Constant.Color.signatureColor
        return label
    }()
    
    private lazy var completeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("완료", for: .normal)
        btn.backgroundColor = Constant.Color.primaryGray
        btn.isEnabled = false
        btn.tintColor = Constant.Color.primaryWhite
        btn.titleLabel?.font = .boldSystemFont(ofSize: 17)
        btn.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    //MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch viewType {
        case .profileSetting:
            navigationItem.title = "PROFILE SETTING"
        case .editProfile:
            navigationItem.title = "EDIT PROFILE"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.title = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavi()
        bind()
    }
    
    //MARK: - Configurations
    
    private func bind() {
        viewModel.outputValidationText.bind { [weak self] value in
            guard let self else { return }
            self.nicknameConditionLabel.text = value
        }
        
        viewModel.outputIsValid.bind { [weak self] value in
            guard let self else { return }
            self.changeDisplayCompleteButton(conditionsSatisfied: value)
        }
        
        viewModel.outputCreateUserDataSucceed.bind { [weak self] isSucceed in
            guard let self else { return }
            if isSucceed {
                switch viewType {
                case .profileSetting:
                    self.changeWindowRootViewController()
                case .editProfile:
                    popViewController()
                }
            }
        }
    }
    
    private func setupNavi() {
        navigationController?.navigationBar.tintColor = Constant.Color.primaryBlack
        switch viewType {
        case .profileSetting:
            navigationItem.title = "PROFILE SETTING"
        
        case .editProfile:
            navigationItem.title = "EDIT PROFILE"
            let save = UIBarButtonItem(title: "저장", style: .done, target: self, action: #selector(completeButtonTapped))
            navigationItem.rightBarButtonItem = save
        }
    }
    
    override func configureLayout() {
        view.addSubview(profileCircleWithCameraIconView)
        profileCircleWithCameraIconView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
        }
        
        view.addSubview(nicknameTextField)
        nicknameTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(30)
            make.top.equalTo(profileCircleWithCameraIconView.snp.bottom).offset(40)
        }
        
        view.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            switch viewType {
            case .profileSetting:
                make.height.equalTo(0.2)
            case .editProfile:
                make.height.equalTo(1)
            }
            make.top.equalTo(nicknameTextField.snp.bottom).offset(10)
        }
        
        view.addSubview(nicknameConditionLabel)
        nicknameConditionLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(20)
            make.top.equalTo(separatorView.snp.bottom).offset(10)
        }
        
        view.addSubview(completeButton)
        completeButton.snp.makeConstraints { make in
            make.top.equalTo(nicknameConditionLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
    }
    
    override func configureUI() {
        super.configureUI()
        DispatchQueue.main.async {
            self.completeButton.layer.cornerRadius = self.completeButton.frame.height / 2
        }
        
        switch viewType {
        case .profileSetting:
            self.profileImage = UIImage(named: Constant.ProfileImage.allCases.randomElement()?.rawValue ?? "profile_0")
            completeButton.isHidden = false
            separatorView.backgroundColor = Constant.Color.primaryLightGray
            nicknameConditionLabel.textColor = Constant.Color.signatureColor
            profileCircleWithCameraIconView.profileImageView.image = self.profileImage
            
        case .editProfile:
            self.profileImage = UIImage(named: UserDefaultsManager.shared.profile ?? "")
            completeButton.isHidden = true
            nicknameTextField.text = UserDefaultsManager.shared.nickname
            separatorView.backgroundColor = Constant.Color.primaryDarkGray
            nicknameConditionLabel.textColor = Constant.Color.primaryDarkGray
            profileCircleWithCameraIconView.profileImageView.image = UIImage(named: UserDefaultsManager.shared.profile ?? "")
        }
    }
    
    //MARK: - Functions
    
    @objc private func profileImageViewTapped() {
        let vc = ProfileImageSettingViewController()
        
        switch self.viewType {
        case .profileSetting:
            vc.viewType = .profileSetting
        case .editProfile:
            vc.viewType = .editProfile
        }
        
        vc.selectedProfileImage = self.profileCircleWithCameraIconView.profileImageView.image
        vc.selectedProfileImageSend = {[weak self] sender in
            guard let self = self else { return }
            self.profileCircleWithCameraIconView.profileImageView.image = sender
            self.profileImage = sender
        }
        pushViewController(vc)
    }
    
    @objc private func completeButtonTapped() {
        viewModel.inputProfileImage.value = self.profileImage
        viewModel.inputCompleteButtonTapped.value = ()
    }
    
    private func changeWindowRootViewController() {
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = scene?.delegate as? SceneDelegate
        sceneDelegate?.window?.rootViewController = MainTabBarController()
        sceneDelegate?.window?.makeKeyAndVisible()
    }
    
    private func changeDisplayCompleteButton(conditionsSatisfied: Bool) {
        
        if conditionsSatisfied {
            switch self.viewType {
            case .profileSetting:
                completeButton.isEnabled = true
                completeButton.backgroundColor = Constant.Color.signatureColor
            
            case .editProfile:
                navigationItem.rightBarButtonItem?.isEnabled = true
            }
        } else {
            switch self.viewType {
            case .profileSetting:
                completeButton.isEnabled = false
                completeButton.backgroundColor = Constant.Color.primaryGray
            
            case .editProfile:
                navigationItem.rightBarButtonItem?.isEnabled = false
            }
        }
    }
}

//MARK: - UITextFieldDelegate

extension ProfileSettingViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        viewModel.inputText.value = textField.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

