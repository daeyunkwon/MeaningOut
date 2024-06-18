//
//  UIViewController+Extension.swift
//  MeaningOut
//
//  Created by 권대윤 on 6/18/24.
//

import UIKit

extension UIViewController {
    func showNetworkConnectFailAlert() {
        let alert = UIAlertController(title: "시스템 알림", message: "네트워크에 연결할 수 없습니다.\n네트워크 상태를 확인 후 다시 시도해 주세요.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { okAction in
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true)
    }
}
