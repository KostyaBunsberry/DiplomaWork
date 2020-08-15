//
//  ProductSaver.swift
//  DiplomaWork
//
//  Created by Kostya Bunsberry on 15.08.2020.
//

import Foundation
import RealmSwift

class ProductSaver {
    
    let realm = try! Realm()
    
    func getProducts() -> [Product] {
        var products = [Product]()
        let realmProducts = realm.objects(ProductRealm.self)
        
        for product in realmProducts {
            products.append(Product(id: "", image: product.image, additionalImages: [], title: product.title, description: "", price: product.price, offers: [product.offer], sortOrder: "0"))
        }
        
        return products
    }
    
    func getObjects() -> Results<ProductRealm> {
        return realm.objects(ProductRealm.self)
    }
    
    func deleteAll() {
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func addProduct(offer: String) {
        let newObject = ProductRealm()
        
        newObject.id = ProductVC.productData.id
        newObject.title = ProductVC.productData.title
        newObject.image = ProductVC.productData.image
        newObject.price = ProductVC.productData.price
        newObject.offer = offer
        
        try! realm.write {
            realm.add(newObject)
        }
    }
    
    func deleteProduct(item: ProductRealm) {
        let realm = try! Realm()
        
        try! realm.write {
            realm.delete(item)
        }
    }
    
}
