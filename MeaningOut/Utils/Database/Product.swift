//
//  Product.swift
//  MeaningOut
//
//  Created by 권대윤 on 7/7/24.
//

import Foundation

import RealmSwift

class Product: Object {
    @Persisted(primaryKey: true) var id: ObjectId //PK
    @Persisted var title: String
    @Persisted var mallName: String
    @Persisted var link: String
    @Persisted var lprice: Int?
    @Persisted var hprice: Int?
    @Persisted var imageID: String
    @Persisted var registrationDate: Date
    @Persisted var isLike: Bool //불필요한 컬럼이겠다!
    @Persisted var productID: String?
    @Persisted var imageURL: String
    
    
    convenience init(title: String, mallName: String, link: String, lprice: Int?, hprice: Int?, productID: String?, imageURL: String) {
        self.init()
        self.title = title
        self.mallName = mallName
        self.link = link
        self.lprice = lprice
        self.hprice = hprice
        self.imageID = "\(self.id)"
        self.registrationDate = Date()
        self.isLike = true
        self.productID = productID
        self.imageURL = imageURL
    }
    
    enum Key: String {
        case id
        case title
        case mallName
        case link
        case lprice
        case hprice
        case imageID
        case registrationDate
    }
}
