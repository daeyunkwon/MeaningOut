//
//  ViewController.swift
//  MeaningOut
//
//  Created by 권대윤 on 6/13/24.
//

import UIKit

import SnapKit

class ViewController: UIViewController {
    
    let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        label.text = "MeaningOut"
        label.font = UIFont(name: "AlfaSlabOne-Regular", size: 30)
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) Font names: \(names)")
        }
        
    }


}

