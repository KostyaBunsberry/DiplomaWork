//
//  ProductCVCell.swift
//  DiplomaWork
//
//  Created by Kostya Bunsberry on 12.08.2020.
//

import UIKit
import RealmSwift

class ProductCVCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var imageImageView: UIImageView!
    
    var productObject: Product!
}
