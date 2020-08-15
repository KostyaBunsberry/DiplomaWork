//
//  CartVC.swift
//  DiplomaWork
//
//  Created by Kostya Bunsberry on 14.08.2020.
//

import UIKit
import Kingfisher

class CartVC: UIViewController, UITableViewDataSource, UITableViewDelegate, CartDelegate {
    
    var products: [Product] = []
    
    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsSelection = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        products = ProductSaver().getProducts()
        
        toggleOrderButton()
        
        tableView.reloadData()
    }
    
    @IBAction func order() {
        
        ProductSaver().deleteAll()
        products.removeAll()
        
        let alertController = UIAlertController(title: "Вроде как заказано", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ок", style: .cancel))
        self.present(alertController, animated: true, completion: nil)
        
        tableView.reloadData()
        toggleOrderButton()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell") as! CartTVCell
        
        cell.productObject = ProductSaver().getObjects()[indexPath.row]
        cell.titleLabel.text = products[indexPath.row].title
        cell.offerLabel.text = products[indexPath.row].offers[0]
        cell.priceLabel.text = products[indexPath.row].price + " ₽"
        
        let url = URL(string: products[indexPath.row].image)
        cell.productImageView.kf.setImage(with: url)
        
        cell.delegate = self
        cell.indexPath = indexPath
        
        return cell
    }
    
    func delete(object: ProductRealm, indexPath: IndexPath) {
        
        ProductSaver().deleteProduct(item: object)
        products.remove(at: indexPath.row)
        
        toggleOrderButton()
        
        tableView.deleteRows(at: [indexPath], with: .automatic)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.6, execute: {
            self.tableView.reloadData()
        })
    }
    
    func toggleOrderButton() {
        if products.count == 0 {
            orderButton.isEnabled = false
            orderButton.backgroundColor = UIColor.tertiaryLabel
        } else {
            orderButton.isEnabled = true
            orderButton.backgroundColor = UIColor.systemBlue
        }
    }

}
