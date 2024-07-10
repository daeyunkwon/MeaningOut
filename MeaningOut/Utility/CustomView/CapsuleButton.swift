//
//  CapsuleButton.swift
//  MeaningOut
//
//  Created by 권대윤 on 6/15/24.
//

import UIKit

final class CapsuleButton: UIButton {
    
    init(title: String, tag: Int) {
        super.init(frame: .zero)
        configureUI()
        self.setTitle(title, for: .normal)
        self.tag = tag
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.layer.borderColor = Constant.Color.primaryLightGray.cgColor
        self.layer.borderWidth = 1
        self.backgroundColor = Constant.Color.primaryWhite
        self.setTitleColor(Constant.Color.primaryBlack, for: .normal)
        self.titleLabel?.font = Constant.Font.system13
    }
}
