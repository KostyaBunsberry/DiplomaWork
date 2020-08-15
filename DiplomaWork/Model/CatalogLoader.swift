//
//  CatalogLoader.swift
//  DiplomaWork
//
//  Created by Kostya Bunsberry on 12.08.2020.
//

import Foundation
import RealmSwift

class Category {
    var id: String
    var image: String
    var title: String
    var sortOrder: Int
    
    init(id: String, image: String, title: String, sortOrder: String) {
        self.id = id
        self.image = image
        self.title = title
        self.sortOrder = Int(sortOrder)!
    }
}

class Product {
    var id: String
    var image: String
    var additionalImages: [String]
    var title: String
    var description: String
    var price: String
    var offers: [String]
    var sortOrder: Int
    
    init(id: String, image: String, additionalImages: [String], title: String, description: String, price: String, offers: [String], sortOrder: String) {
        self.id = id
        self.image = image
        self.additionalImages = additionalImages
        self.title = title
        self.description = description
        self.price = price
        self.offers = offers
        self.sortOrder = Int(sortOrder)!
    }
}

class ProductRealm: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var image: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var price: String = ""
    @objc dynamic var offer: String = ""
}

class CatalogLoader {
    
    func loadCategories(completition: @escaping ([Category]) -> Void) {
        let url = URL(string: "https://blackstarshop.ru/index.php?route=api/v1/categories")!
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, responce, error in
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
               let jsonDict = json as? NSDictionary {
                
                var categories: [Category] = []
                for category in jsonDict {
                    if let categoryData = category.value as? NSDictionary {
                        let key = category.key as! String
                        let imagePath = "https://blackstarshop.ru/\(categoryData["iconImage"] as! String)"
                        
                        categories.append(Category(id: key, image: imagePath, title: categoryData["name"] as! String, sortOrder: categoryData["sortOrder"] as! String))
                    }
                }
                
                DispatchQueue.main.async {
                    completition(categories)
                }
            }
        }
        task.resume()
    }
    
    func loadSubcategories(categoryID: String, completition: @escaping ([Category]) -> Void) {
        print("loading subcategories")
        
        let url = URL(string: "https://blackstarshop.ru/index.php?route=api/v1/categories")!
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, responce, error in
            
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
               let categoriesDict = json as? NSDictionary,
               let categoryDict = categoriesDict[categoryID] as? NSDictionary,
               let subcategoriesArray = categoryDict["subcategories"] as? NSArray {
                
                var subcategories: [Category] = []
                
                for subcategory in subcategoriesArray {
                    if let subcategoryData = subcategory as? NSDictionary {
                        let id = subcategoryData["id"] as? String
                        let imagePath = "https://blackstarshop.ru/\(subcategoryData["iconImage"] as! String)"
                        let title = subcategoryData["name"] as! String
                        let sortOrder = subcategoryData["sortOrder"] as? String
                        
                        subcategories.append(Category(id: id ?? "69", image: imagePath, title: title, sortOrder: sortOrder ?? "899"))
                    }
                }
                
                DispatchQueue.main.async {
                    completition(subcategories)
                }
            }
        }
        task.resume()
    }
    
    func loadItems(subcategoryID:String, completition: @escaping ([Product]) -> Void) {
        let url = URL(string: "https://blackstarshop.ru/index.php?route=api/v1/products&cat_id=\(subcategoryID)")!
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, responce, error in
            
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
               let jsonDict = json as? NSDictionary {
                
                var products: [Product] = []
                for product in jsonDict {
                    if let productData = product.value as? NSDictionary {
                        let title = productData["name"] as! String
                        let imagePath = "https://blackstarshop.ru/\(productData["mainImage"] as! String)"
                        let description = productData["description"] as! String
                        
                        let numberFormatter = NumberFormatter()
                        numberFormatter.maximumFractionDigits = 0
                        numberFormatter.minimumFractionDigits = 0
                        let price = numberFormatter.string(from: NSNumber(value: Float(productData["price"] as! String)!))!
                        
                        let sortOrder = productData["sortOrder"] as? String
                        
                        var additionalImages: [String] = []
                        additionalImages.append(imagePath)
                        
                        if let images = productData["productImages"] as? NSArray {
                            for image in images {
                                if let imageDict = image as? NSDictionary {
                                    additionalImages.append("https://blackstarshop.ru/\(imageDict["imageURL"] as! String)")
                                }
                            }
                        }
                        
                        var offersArray: [String] = []
                        
                        if let offers = productData["offers"] as? NSArray {
                            for offer in offers {
                                if let offersDict = offer as? NSDictionary {
                                    offersArray.append(offersDict["size"] as! String)
                                }
                            }
                        }
                        
                        products.append(Product(id: product.key as! String, image: imagePath, additionalImages: additionalImages, title: title, description: description, price: price, offers: offersArray, sortOrder: sortOrder ?? "899"))
                    }
                }
                DispatchQueue.main.async {
                    completition(products)
                }
            }
        }
        task.resume()
    }
}
