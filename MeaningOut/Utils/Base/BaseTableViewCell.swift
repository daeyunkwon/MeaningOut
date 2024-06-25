//
//  BaseTableViewCell.swift
//  MeaningOut
//
//  Created by 권대윤 on 6/25/24.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
