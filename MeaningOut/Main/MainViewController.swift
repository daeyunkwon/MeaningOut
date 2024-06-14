//
//  MainViewController.swift
//  MeaningOut
//
//  Created by 권대윤 on 6/14/24.
//

import UIKit

import SnapKit

final class MainViewController: UIViewController {
    
    //MARK: - Properties
    
    enum ViewDisplayType {
        case empty
        case nonEmpty
    }
    var viewDisplayType: ViewDisplayType = .nonEmpty {
        didSet {
            self.updateDisplayWithRecentSearch()
        }
    }
    
    var list: [String] = [] {
        didSet {
            if list.isEmpty {
                self.viewDisplayType = .empty
            }
        }
    }
    
    //MARK: - UI Components
    
    private let searchController = UISearchController()
    
    private let tableView = UITableView()
    
    private let emptyRecentSearchImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "empty")
        return iv
    }()
    
    private let emptyRecentSearchLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 검색어가 없어요"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .heavy)
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .heavy)
        label.text = "최근 검색"
        return label
    }()
    
    private lazy var resetButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("전체 삭제", for: .normal)
        btn.titleLabel?.font = Constant.Font.system14
        btn.setTitleColor(Constant.Color.primaryOrange, for: .normal)
        btn.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavi()
        setupSearchController()
        configureLayout()
        configureUI()
        fetchRecentSearchData()
    }
    
    private func fetchRecentSearchData() {
        guard let datas = UserDefaultsManager.shared.recentSearch else {
            self.viewDisplayType = .empty
            self.list = []
            return
        }
        self.viewDisplayType = .nonEmpty
        self.list = datas.reversed() //최근 순 정렬
        self.tableView.reloadData()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RecentSearchTableViewCell.self, forCellReuseIdentifier: RecentSearchTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
    }
    
    private func setupNavi() {
        navigationItem.title = "\(UserDefaultsManager.shared.nickname ?? "")′s MEANING OUT"
        navigationItem.searchController = searchController
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = Constant.Color.primaryWhite
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = Constant.Color.primaryBlack
    }
    
    private func setupSearchController() {
        searchController.searchBar.placeholder = "브랜드, 상품 등을 입력하세요."
        searchController.searchBar.delegate = self
    }
    
    private func configureLayout() {
        view.addSubview(emptyRecentSearchImageView)
        emptyRecentSearchImageView.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.centerY.equalTo(view.safeAreaLayoutGuide).offset(-50)
            make.width.equalTo(view.safeAreaLayoutGuide).inset(70)
            make.height.equalTo(emptyRecentSearchImageView.snp.width)
        }
        
        view.addSubview(emptyRecentSearchLabel)
        emptyRecentSearchLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyRecentSearchImageView.snp.bottom).offset(5)
            make.centerX.equalTo(emptyRecentSearchImageView.snp.centerX)
            make.height.equalTo(30)
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        view.addSubview(resetButton)
        resetButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureUI() {
        view.backgroundColor = Constant.Color.primaryWhite
    }
    
    //MARK: - Functions
    
    private func updateDisplayWithRecentSearch() {
        switch viewDisplayType {
        case .empty:
            emptyRecentSearchImageView.isHidden = false
            emptyRecentSearchLabel.isHidden = false
            titleLabel.isHidden = true
            resetButton.isHidden = true
            tableView.isHidden = true
        case .nonEmpty:
            emptyRecentSearchImageView.isHidden = true
            emptyRecentSearchLabel.isHidden = true
            titleLabel.isHidden = false
            resetButton.isHidden = false
            tableView.isHidden = false
        }
    }
    
    @objc func resetButtonTapped() {
        UserDefaultsManager.shared.removeRecentSearchData()
        fetchRecentSearchData()
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecentSearchTableViewCell.identifier, for: indexPath) as! RecentSearchTableViewCell
        cell.recentSearch = list[indexPath.row]
        return cell
    }
}

//MARK: - UISearchBarDelegate

extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.trimmingCharacters(in: .whitespaces).isEmpty else {return}
        
        if UserDefaultsManager.shared.recentSearch != nil {
            UserDefaultsManager.shared.recentSearch?.append(text)
        } else {
            UserDefaultsManager.shared.recentSearch = [text]
        }
        
        fetchRecentSearchData()
    }
}
