//
//  UIViewController+Extension.swift
//  MeaningOut
//
//  Created by 권대윤 on 6/18/24.
//

import UIKit

extension UIViewController {
    enum AlertType {
        case networkConnectFail
        case urlInvalid
        
        var message: String {
            switch self {
            case .networkConnectFail:
                return "네트워크에 연결할 수 없습니다.\n네트워크 상태를 확인 후 다시 시도해 주세요."
            case .urlInvalid:
                return "해당 상품에 URL 주소가 존재하지 않습니다."
            }
        }
    }
    
    func showNetworkConnectFailAlert(type: AlertType, completion: @escaping (UIAlertAction) -> Void) {
        var alert: UIAlertController
        
        switch type {
        case .networkConnectFail:
            alert = UIAlertController(title: "시스템 알림", message: type.message, preferredStyle: .alert)
        case .urlInvalid:
            alert = UIAlertController(title: "시스템 알림", message: type.message, preferredStyle: .alert)
        }
        
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: completion))
        present(alert, animated: true)
    }
}
