//
//  ProductsVC.swift
//  DiplomaWork
//
//  Created by Kostya Bunsberry on 12.08.2020.
//

import UIKit
import Kingfisher
import JGProgressHUD

class ProductsVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    public static var subcategoryID: String = ""
    var products: [Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = "Загрузка"
        hud.show(in: self.view)
        
        CatalogLoader().loadItems(subcategoryID: ProductsVC.subcategoryID, completition: { products in
            self.products = products.sorted(by: { $0.sortOrder > $1.sortOrder })
            self.collectionView.reloadData()
            hud.dismiss()
        })
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProductCVCell
    
        cell.titleLabel.text = products[indexPath.row].title
        cell.priceLabel.text = products[indexPath.row].price + " ₽"
        
        cell.productObject = products[indexPath.row]
        
        let imageURL = URL(string: products[indexPath.row].image)
        
        let processor = DownsamplingImageProcessor(size: cell.imageImageView.bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: 10)
        
        cell.imageImageView.kf.setImage(with: imageURL, options: [
                                        .processor(processor),
                                        .scaleFactor(UIScreen.main.scale),
                                        .transition(.fade(1)),
                                        .cacheOriginalImage])
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toProductView", sender: nil)
        
        let cell = collectionView.cellForItem(at: indexPath) as! ProductCVCell
        ProductVC.productData = cell.productObject
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = UIScreen.main.bounds.size.width / 2.5
        return CGSize(width: w, height: w * 2)
    }
}
