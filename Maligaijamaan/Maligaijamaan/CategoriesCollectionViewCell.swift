//
//  CategoriesCollectionViewCell.swift
//  Maligaijamaan
//
//  Created by manoj on 03/08/24.
//


import UIKit

protocol CategoryCollectionViewDelaget: AnyObject {
    func categoryButtonTapped(_ cell: CategoriesCollectionViewCell)
}

class CategoriesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var categoryName: UILabel!

    weak var delaget: CategoryCollectionViewDelaget?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        categoryButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
     
        categoryButton.layer.cornerRadius = categoryButton.frame.size.height / 2
        categoryButton.clipsToBounds = true
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        delaget?.categoryButtonTapped(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
      
        categoryButton.layer.cornerRadius = categoryButton.frame.size.height / 2
    }
}
