//
//  ProductRepository.swift
//  MeaningOut
//
//  Created by 권대윤 on 7/7/24.
//

import Foundation

import RealmSwift

class ProductRepository {
    
    private let realm = try! Realm()
    
    func createItem(data: Product) {
        do {
            try realm.write {
                realm.add(data)
                print("Realm Create Succeed")
            }
        } catch {
            print(error)
        }
    }
    
    func fetchAllItem() -> Results<Product> {
        return realm.objects(Product.self).sorted(byKeyPath: Product.Key.registrationDate.rawValue, ascending: false)
    }
    
    func deleteItem(data: Product) {
        do {
            try realm.write {
                ImageFileManager.shared.removeImageFromDocument(filename: data.imageID)
                realm.delete(data)
                print("Realm Delete Succeed")
            }
        } catch {
            print(error)
        }
    }
}
