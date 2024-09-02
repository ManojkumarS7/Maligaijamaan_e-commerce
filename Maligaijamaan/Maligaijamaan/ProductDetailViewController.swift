//
//  ProductDetailViewController.swift
//  Maligaijamaan
//
//  Created by manoj on 03/08/24.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    var product: Product?
    
    @IBOutlet var productImage: UIImageView!
    @IBOutlet var productName: UILabel!
    @IBOutlet var quantity: UILabel!
    @IBOutlet var productPrice: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let product = product {
            productName.text = product.name
            productPrice.text = "\(product.price) INR"
            quantity.text = product.quantity
            if let imageUrl = URL(string: product.image) {
                URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                    if let error = error {
                        print("Failed to fetch image", error)
                        return
                    }
                    
                    guard let data = data else { return }
                    DispatchQueue.main.async {
                        self.productImage.image = UIImage(data: data)
                    }
                }.resume()
            }
        }
        
        UserDefaults.standard.setValue(product?.name, forKey: "name")
        UserDefaults.standard.setValue(product?.price, forKey: "price")
        UserDefaults.standard.setValue(product?.id, forKey: "id")
        UserDefaults.standard.setValue(product?.quantity, forKey: "qty")
    }
    

}
