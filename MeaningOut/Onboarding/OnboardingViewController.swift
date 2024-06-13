//
//  Onboarding.swift
//  MeaningOut
//
//  Created by 권대윤 on 6/13/24.
//

import UIKit

import SnapKit

final class OnboardingViewController: UIViewController {
    
    //MARK: - UI Components
    
    private let logoTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "MeaningOut"
        label.textAlignment = .center
        label.font = UIFont(name: "AlfaSlabOne-Regular", size: 40)
        label.textColor = Constant.Color.primaryOrange
        return label
    }()
    
    private let mainImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "launch")
        return iv
    }()
    
    private lazy var startButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("시작하기", for: .normal)
        btn.backgroundColor = Constant.Color.primaryOrange
        btn.layer.cornerRadius = 24
        btn.tintColor = Constant.Color.primaryWhite
        btn.titleLabel?.font = .boldSystemFont(ofSize: 17)
        btn.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavi()
        configureLayout()
        configureUI()
    }
    
    private func setupNavi() {
        navigationItem.title = ""
        navigationController?.navigationBar.tintColor = Constant.Color.primaryBlack
    }
    
    private func configureLayout() {
        view.addSubview(logoTitleLabel)
        logoTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(72)
            make.width.equalTo(361)
        }
        
        view.addSubview(mainImageView)
        mainImageView.snp.makeConstraints { make in
            make.width.equalTo(350)
            make.height.equalTo(263.33)
            make.center.equalToSuperview()
        }
        
        view.addSubview(startButton)
        startButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
    }
    
    private func configureUI() {
        view.backgroundColor = Constant.Color.primaryWhite
    }
    
    //MARK: - Functions
    
    @objc func startButtonTapped() {
        let vc = ProfileSettingViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
