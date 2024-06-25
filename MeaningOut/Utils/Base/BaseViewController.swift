//
//  BaseViewController.swift
//  MeaningOut
//
//  Created by 권대윤 on 6/25/24.
//

import UIKit

class BaseViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        configureUI()
    }
    
    func configureLayout() {
        
    }
    
    func configureUI() {
        view.backgroundColor = Constant.Color.primaryWhite
    }
}
