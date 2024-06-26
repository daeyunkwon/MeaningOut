//
//  Onboarding.swift
//  MeaningOut
//
//  Created by 권대윤 on 6/13/24.
//

import UIKit

import SnapKit

final class OnboardingViewController: BaseViewController {
    
    //MARK: - UI Components
    
    private let logoTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "MeaningOut"
        label.textAlignment = .center
        label.font = Constant.Font.alfaSlabOne40
        label.textColor = Constant.Color.signatureColor
        return label
    }()
    
    private let mainImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = Constant.Image.launch
        return iv
    }()
    
    private lazy var startButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("시작하기", for: .normal)
        btn.backgroundColor = Constant.Color.signatureColor
        btn.layer.cornerRadius = 24
        btn.tintColor = Constant.Color.primaryWhite
        btn.titleLabel?.font = .boldSystemFont(ofSize: 17)
        btn.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    //MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavi()
    }
    
    private func setupNavi() {
        navigationItem.title = ""
        navigationController?.navigationBar.tintColor = Constant.Color.primaryBlack
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = Constant.Color.primaryWhite
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    override func configureLayout() {
        view.addSubview(logoTitleLabel)
        logoTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(72)
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
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(50)
        }
    }
    
    override func configureUI() {
        super.configureUI()
    }
    
    //MARK: - Functions
    
    @objc private func startButtonTapped() {
        let vc = ProfileSettingViewController()
        pushViewController(vc)
    }
}
