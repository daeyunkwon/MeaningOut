//
//  Shopping.swift
//  MeaningOut
//
//  Created by 권대윤 on 6/15/24.
//

import Foundation

struct Shopping: Codable {
    let total: Int?
    let items: [ShoppingItem]
}

struct ShoppingItem: Codable {
    let title: String?
    let link: String?
    let image: String?
    let lprice: String?
    let hprice: String?
    let mallName: String?
    let productId: String?
    
    var linkURL: String {
        guard let link = self.link, !link.isEmpty else { return "" }
        return link.replacingOccurrences(of: #"\"#, with: "")
    }
    
    var imageURL: String {
        guard let image = self.image else { return "" }
        return image.replacingOccurrences(of: #"\"#, with: "")
    }
    
    var priceString: String {
        var price = 0
        
        if !(self.lprice ?? "").isEmpty {
            price = Int(lprice ?? "") ?? 0
        } else if !(self.hprice ?? "").isEmpty {
            price = Int(hprice ?? "") ?? 0
        }
        
        return price.formatted()
    }
    
    var titleString: String {
        guard let title = self.title else { return "" }
        return title.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
