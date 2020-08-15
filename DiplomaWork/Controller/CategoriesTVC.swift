//
//  CategoriesTVC.swift
//  DiplomaWork
//
//  Created by Kostya Bunsberry on 12.08.2020.
//

import UIKit
import Kingfisher
import JGProgressHUD

class CategoriesTVC: UITableViewController {
    
    var categories: [Category] = []
    var page: Int = 0
    var categoryID = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = "Загрузка"
        hud.show(in: self.view)
        
        if page == 0 {
            CatalogLoader().loadCategories(completition: { categories in
                self.categories = categories.sorted(by: {
                    $0.sortOrder < $1.sortOrder
                })
                
                self.tableView.reloadData()
                hud.dismiss()
            })
        } else {
            CatalogLoader().loadSubcategories(categoryID: categoryID, completition: { categories in
                self.categories = categories.sorted(by: {
                    $0.sortOrder < $1.sortOrder
                })
                
                self.tableView.reloadData()
                hud.dismiss()
            })
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell") as! CategoryTVCell
        
        cell.id = categories[indexPath.row].id
        cell.categoryTitle.text = categories[indexPath.row].title
        
        let url = URL(string: categories[indexPath.row].image)
        let processor = DownsamplingImageProcessor(size: cell.categoryImage.bounds.size)
        
        cell.categoryImage.kf.setImage(with: url, options: [
                                        .processor(processor),
                                        .scaleFactor(UIScreen.main.scale),
                                        .transition(.fade(0.5)),
                                        .cacheOriginalImage])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if page == 0 {
//            performSegue(withIdentifier: "toSubcategories", sender: nil)
            let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "categoriesVC") as! CategoriesTVC
            nextVC.page = 1
            
            let cell = tableView.cellForRow(at: indexPath) as! CategoryTVCell
            nextVC.categoryID = cell.id
            
            show(nextVC, sender: nil)
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            performSegue(withIdentifier: "toProducts", sender: nil)
            let cell = tableView.cellForRow(at: indexPath) as! CategoryTVCell
            
            ProductsVC.subcategoryID = cell.id
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "toSubcategories" {
            guard let destinationVC = segue.destination as? CategoriesTVC else { return }
            destinationVC.page = 1
        }
    }

}
