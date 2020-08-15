//
//  CartTVCell.swift
//  DiplomaWork
//
//  Created by Kostya Bunsberry on 14.08.2020.
//

import UIKit

protocol CartDelegate {
    func delete(object: ProductRealm, indexPath: IndexPath)
}

class CartTVCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var offerLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    
    var productObject: ProductRealm!
    var delegate: CartDelegate!
    var indexPath: IndexPath!
    
    @IBAction func delete() {
        delegate?.delete(object: productObject, indexPath: indexPath)
    }

}
