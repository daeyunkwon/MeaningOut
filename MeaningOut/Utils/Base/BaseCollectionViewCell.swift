//
//  BaseCollectionViewCell.swift
//  MeaningOut
//
//  Created by 권대윤 on 6/25/24.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLayout() {
        
    }
    
    func configureUI() {
        
    }
}
