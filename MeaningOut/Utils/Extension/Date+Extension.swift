//
//  Date+Extension.swift
//  MeaningOut
//
//  Created by 권대윤 on 6/14/24.
//

import UIKit

extension Date {
    static var todayDate: String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. MM. dd"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}
