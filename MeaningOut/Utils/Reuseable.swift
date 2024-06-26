//
//  Reuseable.swift
//  MeaningOut
//
//  Created by 권대윤 on 6/14/24.
//

import UIKit

protocol Reuseable: AnyObject {
    static var identifier: String {get}
}

extension UIView: Reuseable {
    static var identifier: String {
        return String(describing: self)
    }
}
