//
//  Protocols.swift
//  MeaningOut
//
//  Created by 권대윤 on 6/15/24.
//

import UIKit

protocol RecentSearchTableViewCellDelegate: AnyObject {
    func removeButtonTapped(cell: RecentSearchTableViewCell)
}
