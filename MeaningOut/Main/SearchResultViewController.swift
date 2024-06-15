//
//  SearchResultViewController.swift
//  MeaningOut
//
//  Created by 권대윤 on 6/15/24.
//

import UIKit

import Alamofire
import SnapKit

final class SearchResultViewController: UIViewController {
    
    //MARK: - Properties
    
    var searchKeyword: String?
    
    var list: [ShoppingItem] = []
    
    //MARK: - UI Components
    
    private let resultCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .heavy)
        label.textColor = Constant.Color.primaryOrange
        label.text = "888,888개의 검색 결과"
        return label
    }()
    
    private let capsuleAccuracyButton = CapsuleButton(title: "정확도", tag: 0)
    private let capsuleDateButton = CapsuleButton(title: "날짜순", tag: 1)
    private let capsuleHighPriceButton = CapsuleButton(title: "가격높은순", tag: 2)
    private let capsuleRowPriceButton = CapsuleButton(title: "가격낮은순", tag: 3)
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNavi()
        configureLayout()
        configureUI()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SearchResultCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultCollectionViewCell.identifier)
    }
    
    private func setupNavi() {
        navigationItem.title = self.searchKeyword
    }
    
    private func configureLayout() {
        view.addSubview(resultCountLabel)
        resultCountLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        view.addSubview(capsuleAccuracyButton)
        capsuleAccuracyButton.snp.makeConstraints { make in
            make.top.equalTo(resultCountLabel.snp.bottom).offset(15)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.width.equalTo(60)
            make.height.equalTo(35)
        }
        
        view.addSubview(capsuleDateButton)
        capsuleDateButton.snp.makeConstraints { make in
            make.top.equalTo(capsuleAccuracyButton.snp.top)
            make.leading.equalTo(capsuleAccuracyButton.snp.trailing).offset(5)
            make.width.equalTo(60)
            make.height.equalTo(35)
        }
        
        view.addSubview(capsuleHighPriceButton)
        capsuleHighPriceButton.snp.makeConstraints { make in
            make.top.equalTo(capsuleDateButton.snp.top)
            make.leading.equalTo(capsuleDateButton.snp.trailing).offset(5)
            make.width.equalTo(80)
            make.height.equalTo(35)
        }
        
        view.addSubview(capsuleRowPriceButton)
        capsuleRowPriceButton.snp.makeConstraints { make in
            make.top.equalTo(capsuleHighPriceButton.snp.top)
            make.leading.equalTo(capsuleHighPriceButton.snp.trailing).offset(5)
            make.width.equalTo(80)
            make.height.equalTo(35)
        }
                                
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(capsuleAccuracyButton.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureUI() {
        view.backgroundColor = Constant.Color.primaryWhite
        [capsuleAccuracyButton, capsuleDateButton, capsuleHighPriceButton, capsuleRowPriceButton].forEach {
            $0.layoutIfNeeded()
            $0.addTarget(self, action: #selector(capsuleOptionButtonTapped), for: .touchUpInside)
        }
    }
    
    static func layout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let cellCount: CGFloat = 2
        let sectionSpacing: CGFloat = 20
        let cellSpacing: CGFloat = 20
        let width = UIScreen.main.bounds.width - ((cellSpacing * (cellCount - 1)) + (sectionSpacing * 2))
        layout.itemSize = CGSize(width: width / cellCount, height: width / cellCount * 1.7)
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: sectionSpacing, left: sectionSpacing, bottom: sectionSpacing, right: sectionSpacing)
        layout.scrollDirection = .vertical
        return layout
    }
    
    //MARK: - Functions
    
    @objc func capsuleOptionButtonTapped(sender: UIButton) {
        print(#function, sender.tag)
    }

}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCollectionViewCell.identifier, for: indexPath) as! SearchResultCollectionViewCell
        
        return cell
    }
}
