//
//  ProductTableViewCell.swift
//  Maligaijamaan
//
//  Created by manoj on 03/08/24.
//

import Foundation


import UIKit

protocol ProductTableViewDelegate: AnyObject {
    func didTapCartButton(with product: Product)
    func didTapBuyButton(with product: Product)
    func didUpdateQuantity(for product: Product, updatedQuantity: Int)
}

class ProductTableViewCell: UITableViewCell {
    
    @IBOutlet var productImage: UIImageView!
    @IBOutlet var productName: UILabel!
    @IBOutlet var productPrice: UILabel!
    @IBOutlet var cartButton: UIButton!
    @IBOutlet var quantity: UILabel!
    @IBOutlet var quantityType: UILabel!
    
    weak var delegate: ProductTableViewDelegate?
    var product: Product?
    var updatedQuantity: Int!
    
    @IBAction func cartButtonTapped(_ sender: Any) {
        guard let product = product else { return }
        delegate?.didTapCartButton(with: product)
    }
    
    @IBAction func BuyNowButtonTapped(_ sender: Any) {
        guard let product = product else { return }
        delegate?.didTapBuyButton(with: product)
    }
    
    @IBAction func incrButtonTapped(_ sender: Any) {
        guard let presentValue = Int(quantity.text!) else { return }
        updatedQuantity = presentValue + 1
        quantity.text = String(updatedQuantity)
        product?.quantity = String(updatedQuantity)
        updatePrice()
        
        if let product = product {
               delegate?.didUpdateQuantity(for: product, updatedQuantity: updatedQuantity)
           }
    }
    
    @IBAction func decButtonTapped(_ sender: Any) {
        guard let presentValue = Int(quantity.text!), presentValue > 1 else { return }
        updatedQuantity = presentValue - 1
        quantity.text = String(updatedQuantity)
        product?.quantity = String(updatedQuantity)
        updatePrice()
        if let product = product {
                delegate?.didUpdateQuantity(for: product, updatedQuantity: updatedQuantity)
            }
    }
    private func updateQuantityAndPrice() {
           quantity.text = String(updatedQuantity)
           product?.quantity = String(updatedQuantity)
           updatePrice()
       }
    
    private func updatePrice() {

        let productPriceValue = product?.price
        var newPrice = productPriceValue! * Double(updatedQuantity)
        productPrice.text = String(format: "%.2f inr", newPrice)
        product?.price = newPrice
        
    }
}
