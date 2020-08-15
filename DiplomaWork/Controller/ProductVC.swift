//
//  ProductVC.swift
//  DiplomaWork
//
//  Created by Kostya Bunsberry on 12.08.2020.
//

import UIKit
import FSPagerView
import Kingfisher

class ProductVC: UIViewController, FSPagerViewDataSource, FSPagerViewDelegate {
    
    public static var productData: Product!
    
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        titleLabel.text = ProductVC.productData.title
        descriptionLabel.text = ProductVC.productData.description
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        pagerView.reloadData()
    }
    
    @IBAction func buy() {
        let alertController = UIAlertController(title: "Выбор размера", message: nil, preferredStyle: .actionSheet)
        
        for offer in ProductVC.productData.offers {
            let action = UIAlertAction(title: offer, style: .default) { (action:UIAlertAction) in
                ProductSaver().addProduct(offer: offer)
            }
            alertController.addAction(action)
        }

        let cancel = UIAlertAction(title: "Отменить", style: .cancel)
        
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return ProductVC.productData.additionalImages.count
    }
        
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        
        cell.imageView?.contentMode = .scaleAspectFit
        
        let url = URL(string: ProductVC.productData.additionalImages[index])
        let processor = DownsamplingImageProcessor(size: (cell.imageView?.bounds.size)!)
        
        cell.imageView?.kf.setImage(with: url,
                                    options: [
                                        .processor(processor),
                                        .scaleFactor(UIScreen.main.scale),
                                        .transition(.fade(0.2)),
                                        .cacheOriginalImage])
        
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, shouldHighlightItemAt index: Int) -> Bool {
        return false
    }

}
