//
//  CartTableViewCell.swift
//  Maligaijamaan
//
//  Created by manoj on 03/08/24.
//

import UIKit

protocol CartViewDelegate: AnyObject {
    func didRemoveButtonTapped(with cart: CartData)
}

class CartTableViewCell: UITableViewCell {
    
    @IBOutlet var cartImage: UIImageView!
    @IBOutlet var cartName: UILabel!
    @IBOutlet var cartPrice: UILabel!
    
    weak var delegate: CartViewDelegate?
    var removeCart: CartData?
    
    
    
    
    @IBAction func removeButtonTapped(_ sender: Any) {
        guard let removeCart = removeCart else { return }
        print("Remove button tapped")
        print(removeCart)
        delegate?.didRemoveButtonTapped(with: removeCart)
    }
    
    
    
    
}
