//
//  SettingViewController.swift
//  MeaningOut
//
//  Created by 권대윤 on 6/16/24.
//

import UIKit

import SnapKit

final class SettingViewController: UIViewController {
    
    //MARK: - Properties
    
    private enum SettingOptions: String, CaseIterable {
        case myLikeList = "나의 장바구니 목록"
        case commonQuestion = "자주 묻는 질문"
        case inquiry = "1:1 문의"
        case notificationSetting = "알림 설정"
        case withdrawal = "탈퇴하기"
    }
    
    //MARK: - UI Components
    
    private let tableView = UITableView()
    
    
    //MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavi()
        configureLayout()
        configureUI()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingOptionTableViewCell.self, forCellReuseIdentifier: SettingOptionTableViewCell.identifier)
        tableView.register(SettingProfileTableViewCell.self, forCellReuseIdentifier: SettingProfileTableViewCell.identifier)
        tableView.separatorStyle = .none
    }
    
    private func setupNavi() {
        navigationItem.title = "SETTING"
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = Constant.Color.primaryWhite
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func configureLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    private func configureUI() {
        view.backgroundColor = Constant.Color.primaryWhite
    }
    
    //MARK: - Functions
    
    private func showWithdrawalAlert() {
        let alert = UIAlertController(title: "탈퇴하기", message: "탈퇴를 하면 데이터가 모두 초기화됩니다. 탈퇴 하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .destructive, handler: { okAction in
            UserDefaultsManager.shared.removeUserData {
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let sceneDelegate = windowScene?.delegate as? SceneDelegate
                sceneDelegate?.window?.rootViewController = UINavigationController(rootViewController: OnboardingViewController())
                sceneDelegate?.window?.makeKeyAndVisible()
            }
        }))
        present(alert, animated: true)
    }   
}

//MARK: - UITableViewDataSource, UITableViewDelegate

extension SettingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 120
        } else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingOptions.allCases.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingProfileTableViewCell.identifier, for: indexPath) as! SettingProfileTableViewCell
            cell.selectionStyle = .default
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingOptionTableViewCell.identifier, for: indexPath) as! SettingOptionTableViewCell
            
            if indexPath.row == 1 {
                cell.likeCountButton.isHidden = false
                cell.titleLabel.text = SettingOptions.allCases[indexPath.row-1].rawValue
                cell.configureAttributedStringForLikeCountButton()
                cell.selectionStyle = .none
            } else {
                if indexPath.row == 5 {
                    cell.selectionStyle = .default
                } else  {
                    cell.selectionStyle = .none
                }
                
                cell.likeCountButton.isHidden = true
                cell.titleLabel.text = SettingOptions.allCases[indexPath.row-1].rawValue
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
        } else if indexPath.row == 5 {
            self.showWithdrawalAlert()
        }
        tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .automatic)
    }
}
