//
//  SettingViewController.swift
//  MeaningOut
//
//  Created by 권대윤 on 6/16/24.
//

import UIKit

import SnapKit

final class SettingViewController: BaseViewController {
    
    //MARK: - Properties
    
    private enum SettingOptions: Int, CaseIterable {
        case myLikeList = 1
        case commonQuestion
        case inquiry
        case notificationSetting
        case withdrawal
    }
    
    private let repository = ProductRepository()
    
    //MARK: - UI Components
    
    private let tableView = UITableView()
    
    //MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        navigationItem.title = "SETTING"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.title = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavi()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingOptionTableViewCell.self, forCellReuseIdentifier: SettingOptionTableViewCell.identifier)
        tableView.register(SettingProfileTableViewCell.self, forCellReuseIdentifier: SettingProfileTableViewCell.identifier)
        tableView.separatorStyle = .none
    }
    
    private func setupNavi() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = Constant.Color.primaryWhite
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    override func configureLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    //MARK: - Functions
    
    private func showWithdrawalAlert() {
        let alert = UIAlertController(title: "탈퇴하기", message: "탈퇴를 하면 데이터가 모두 초기화됩니다. 탈퇴 하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .destructive, handler: { okAction in
            self.repository.deleteAllItem()
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
        
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingProfileTableViewCell.identifier, for: indexPath) as? SettingProfileTableViewCell else {
                print("Failed to dequeue a SettingProfileTableViewCell. Using default UITableViewCell.")
                return UITableViewCell()
            }
            cell.configureUI()
            return cell
            
        case SettingOptions.allCases[indexPath.row-1].rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingOptionTableViewCell.identifier, for: indexPath) as? SettingOptionTableViewCell else {
                print("Failed to dequeue a SettingOptionTableViewCell. Using default UITableViewCell.")
                return UITableViewCell()
            }
            cell.cellConfig(type: SettingOptionTableViewCell.CellType(rawValue: SettingOptions.allCases[indexPath.row-1].rawValue) ?? .myLikeList)
            return cell
        
        default:
            print("Failed to dequeue a CustomTableViewCell. Using default UITableViewCell.")
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = ProfileSettingViewController()
            vc.viewType = .editProfile
            pushViewController(vc)
        } else if indexPath.row == 5 {
            self.showWithdrawalAlert()
        }
        tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .automatic)
    }
}
