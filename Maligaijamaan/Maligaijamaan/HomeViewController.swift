//
//  ViewController.swift
//  Maligaijamaan
//
//  Created by manoj on 02/08/24.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, CategoryCollectionViewDelaget {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var categoriesCollection: UICollectionView!
    
    var categories: [Category] = []
    let Offerrimage = UIImage(named: "offer")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .clear
        
        categoriesCollection.delegate = self
        categoriesCollection.dataSource = self
        
 print("hii")
        
        navigationItem.hidesBackButton = true
        

        
        fetchCategories()
    }
    
    func fetchCategories() {
        let urlString = "https://maligaijaman.rdegi.com/api/categorylist.php"
        guard let url = URL(string: urlString) else {
            print("Wrong URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let allCategories = try JSONDecoder().decode([Category].self, from: data)
                    self.categories = allCategories.filter { $0.delete_flag == "0" }
                    DispatchQueue.main.async {
                        self.categoriesCollection.reloadData()
                    }
                } catch {
                    print("Failed to parse JSON")
                }
            }
        }.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return 4
        } else {
            return categories.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCollectionViewCell
            cell.offerImageView.image = Offerrimage
            return cell
        } else {
            let cell = categoriesCollection.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoriesCollectionViewCell
            let category = categories[indexPath.item]
            cell.categoryName.text = category.name
            cell.delaget = self
            cell.categoryButton.setImage(nil, for: .normal)
            if let url = URL(string: category.imgpath) {
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url), let image = UIImage(data: data)  {
                     
                       
                        DispatchQueue.main.async {
                            if collectionView.indexPath(for: cell) == indexPath {
                                cell.categoryButton.setImage(image, for: .normal)
                            }
                        }
                    }
                }
            }
            return cell
        }
    }

    func categoryButtonTapped(_ cell: CategoriesCollectionViewCell) {
        if let indexPath = categoriesCollection.indexPath(for: cell) {
            let category = categories[indexPath.item]
            UserDefaults.standard.setValue(category.id, forKey: "categoryid")
            print("Category ID: \(category.id)")
            print("Category tapped: \(category.name)")
            self.performSegue(withIdentifier: "Productlist", sender: self)
        }
    }
    
   
}


