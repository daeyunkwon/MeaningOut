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
    
    func isItemSaved(productID: String) -> Bool {
        let result = realm.objects(Product.self).where {
            $0.productID == productID
        }
        
        if result.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    func fetchItem(productID: String) -> Product? {
        let result = realm.objects(Product.self).where {
            $0.productID == productID
        }
        return result.first
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
    
    func deleteAllItem() {
        do {
            try realm.write {
                realm.deleteAll()
                print("Realm All Data Delete Succeed")
            }
        } catch {
            print(error)
        }
    }
    
    
}
