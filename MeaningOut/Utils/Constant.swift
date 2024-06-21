//
//  Constant.swift
//  MeaningOut
//
//  Created by 권대윤 on 6/13/24.
//

import UIKit

enum Constant {
    enum Color {
        static let signatureColor = UIColor(red: 0.32, green: 0.71, blue: 0.80, alpha: 1.00)
        static let primaryBlack = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.00)
        static let primaryGray = UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1.00)
        static let primaryDarkGray = UIColor(red: 0.30, green: 0.30, blue: 0.30, alpha: 1.00)
        static let primaryLightGray = UIColor(red: 0.80, green: 0.80, blue: 0.80, alpha: 1.00)
        static let primaryWhite = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
    }
    
    enum Font {
        static let system16 = UIFont.systemFont(ofSize: 16)
        static let system15 = UIFont.systemFont(ofSize: 15)
        static let system14 = UIFont.systemFont(ofSize: 14)
        static let system13 = UIFont.systemFont(ofSize: 13)
    }
    
    enum SymbolSize {
        static func smallSize(systemName: String) -> UIImage? {
            let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .small)
            let image = UIImage(systemName: systemName, withConfiguration: config)
            return image
        }
        
        static func smallBoldSize(systemName: String) -> UIImage? {
            let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .small)
            let image = UIImage(systemName: systemName, withConfiguration: config)
            return image
        }
    }
    
    enum ProfileImage: String, CaseIterable {
        case profile_0
        case profile_1
        case profile_2
        case profile_3
        case profile_4
        case profile_5
        case profile_6
        case profile_7
        case profile_8
        case profile_9
        case profile_10
        case profile_11
    }
}
