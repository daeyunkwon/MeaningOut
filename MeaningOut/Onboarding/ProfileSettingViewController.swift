//
//  ViewController.swift
//  MeaningOut
//
//  Created by 권대윤 on 6/13/24.
//

import UIKit

import SnapKit

final class ProfileSettingViewController: UIViewController {
    
    //MARK: - Properties
    
    
    
    //MARK: - UI Components
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = Constant.Color.primaryWhite
        iv.contentMode = .scaleAspectFill
        iv.layer.borderWidth = 5
        iv.alpha = 1
        iv.layer.borderColor = Constant.Color.primaryOrange.cgColor
        iv.layer.cornerRadius = 60
        iv.clipsToBounds = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(profileImageViewTapped))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private let cameraIconButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(Constant.SymbolSize.smallSize(systemName: "camera.fill"), for: .normal)
        btn.setTitle("", for: .normal)
        btn.tintColor = Constant.Color.primaryWhite
        btn.backgroundColor = Constant.Color.primaryOrange
        btn.layer.cornerRadius = 20
        return btn
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
        label.textColor = Constant.Color.primaryOrange
        return label
    }()
    
    private lazy var completeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("완료", for: .normal)
        btn.backgroundColor = Constant.Color.primaryGray
        btn.isEnabled = false
        btn.layer.cornerRadius = 24
        btn.tintColor = Constant.Color.primaryWhite
        btn.titleLabel?.font = .boldSystemFont(ofSize: 17)
        btn.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    //MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "PROFILE SETTING"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.title = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        configureUI()
    }
    
    private func configureLayout() {
        view.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
        }
        profileImageView.image = UIImage(named: "profile_0")
        
        view.addSubview(cameraIconButton)
        cameraIconButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.trailing.equalTo(profileImageView.snp.trailing)
            make.bottom.equalTo(profileImageView.snp.bottom)
        }
        
        view.addSubview(nicknameTextField)
        nicknameTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(30)
            make.top.equalTo(profileImageView.snp.bottom).offset(40)
        }
        
        view.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(0.2)
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
    
    private func configureUI() {
        view.backgroundColor = Constant.Color.primaryWhite
        profileImageView.image = UIImage(named: Constant.ProfileImage.allCases.randomElement()?.rawValue ?? "profile_0")
    }
    
    //MARK: - Functions
    
    @objc func profileImageViewTapped() {
        navigationController?.pushViewController(ProfileImageSettingViewController(), animated: true)
    }
    
    @objc func completeButtonTapped() {
        print(#function)
    }
    
    private func updateStatusCompleteButton() {
        guard let text = nicknameTextField.text else {return}
        
        if text.count >= 2 && text.count < 10 && !text.contains("@") && !text.contains("#") && !text.contains("$") && !text.contains("%") && !text.contains("1") && !text.contains("2") && !text.contains("3") && !text.contains("4") && !text.contains("5") && !text.contains("6") && !text.contains("7") && !text.contains("8") && !text.contains("9") && !text.contains("0") {
            completeButton.isEnabled = true
            completeButton.backgroundColor = Constant.Color.primaryOrange
        } else {
            completeButton.isEnabled = false
            completeButton.backgroundColor = Constant.Color.primaryGray
        }
    }
    
    private func updateStatusNicknameConditionLabel() {
        guard let text = nicknameTextField.text else {return}
        
        if text.trimmingCharacters(in: .whitespaces).isEmpty {
            self.nicknameConditionLabel.text = nil
            return
        }
        
        if text.contains("@") || text.contains("#") || text.contains("$") || text.contains("%") {
            self.nicknameConditionLabel.text = "닉네임에 @, #, $, % 는 포함할 수 없어요."
            return
        }
        
        if text.count < 2 || text.count >= 10 {
            self.nicknameConditionLabel.text = "2글자 이상 10글자 미만으로 설정해주세요."
            return
        } else {
            if text.contains("1") || text.contains("2") || text.contains("3") || text.contains("4") || text.contains("5") || text.contains("6") || text.contains("7") || text.contains("8") || text.contains("9") || text.contains("0") {
                self.nicknameConditionLabel.text = "닉네임에 숫자는 포함할 수 없어요."
                return
            } else {
                self.nicknameConditionLabel.text = "사용 가능한 닉네임입니다."
            }
        }
    }
}

//MARK: - UITextFieldDelegate

extension ProfileSettingViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.updateStatusNicknameConditionLabel()
        self.updateStatusCompleteButton()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

