//
//  SubcategoriesTVC.swift
//  DiplomaWork
//
//  Created by Kostya Bunsberry on 12.08.2020.
//

import UIKit
import Kingfisher
import JGProgressHUD

class SubcategoriesTVC: UITableViewController {
    
    public static var categoryID: String = ""
    var subcategories: [Category] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = "Загрузка"
        hud.show(in: self.view)

        CatalogLoader().loadSubcategories(categoryID: SubcategoriesTVC.categoryID, completition: { subcategories in
            self.subcategories = subcategories.sorted(by: {
                $0.sortOrder < $1.sortOrder
            })
            
            self.tableView.reloadData()
            hud.dismiss()
        })
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subcategories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell") as! CategoryTVCell
        
        cell.id = subcategories[indexPath.row].id
        cell.categoryTitle.text = subcategories[indexPath.row].title
        
        let url = URL(string: subcategories[indexPath.row].image)
        let processor = DownsamplingImageProcessor(size: cell.categoryImage.bounds.size)
        
        cell.categoryImage.kf.setImage(with: url, options: [
                                        .processor(processor),
                                        .scaleFactor(UIScreen.main.scale),
                                        .transition(.fade(0.5)),
                                        .cacheOriginalImage])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toProducts", sender: nil)
        let cell = tableView.cellForRow(at: indexPath) as! CategoryTVCell
        
        ProductsVC.subcategoryID = cell.id
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
