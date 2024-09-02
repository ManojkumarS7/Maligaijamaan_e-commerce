//
//  ProductViewController.swift
//  Maligaijamaan
//
//  Created by manoj on 03/08/24.
//


import UIKit

class ProductViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ProductTableViewDelegate {

    var products = [Product]()
    var filteredProducts = [Product]()
    
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        fetchProducts()
    }
    
    func fetchProducts() {
        let urlString = "https://maligaijaman.rdegi.com/api/productlist.php"
        
        let categoryID = UserDefaults.standard.string(forKey: "categoryid")
        print(categoryID!)
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Failed to fetch products:", error)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let products = try JSONDecoder().decode([Product].self, from: data)
                
                self.filteredProducts = products.filter { $0.categoryId.trimmingCharacters(in: .whitespaces) == categoryID }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let jsonError {
                print("Failed to decode JSON:", jsonError)
            }
        }.resume()
    }
    
    func postProduct(with product: Product) {
        // Retrieve token and key from UserDefaults
        guard let token = UserDefaults.standard.string(forKey: "jwt"),
              let key = UserDefaults.standard.string(forKey: "key") else {
            print("No token or key found")
            return
        }
        
        let parameter: [String: String] = [
            "secretkey": key,
            "jwt": token,
            "productid": product.id,
            "productname": product.name
        ]
        
        // Define the URL string
        let urlString = "https://maligaijaman.rdegi.com/api/cart_insert.php"
        
        let session = URLSession.shared
        
        // Create the URL
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let body = createFormBody(with: parameter, boundary: boundary)
        request.httpBody = body
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response from the server")
                return
            }
            
            guard let responseData = data else {
                print("nil data received from the server")
                return
            }
            
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as? [String: Any] {
                    print(jsonResponse)
                } else {
                    print("data maybe in wrong format")
                    throw URLError(.badServerResponse)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }

    func createFormBody(with parameters: [String: String], boundary: String) -> Data {
        var body = Data()
        
        for (key, value) in parameters {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        return body
    }

    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredProducts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductTableViewCell
        let product = filteredProducts[indexPath.row]
        cell.productName.text = product.name
        cell.productPrice.text = "\(product.price)"
        cell.quantity.text = product.quantity
        cell.quantityType.text = product.quantityType
        cell.product = product
        cell.delegate = self
        
        // Fetch the product image
        if let imageUrl = URL(string: product.image) {
            URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                if let error = error {
                    print("Failed to fetch image:", error)
                    return
                }
                
                guard let data = data else { return }
                
                DispatchQueue.main.async {
                    cell.productImage.image = UIImage(data: data)
                }
            }.resume()
        }
        
        return cell
    }

    func didTapCartButton(with product: Product) {
        print("Product added to cart: \(product)")
        showAlert(message: "Product added to cart")
        postProduct(with: product)
    }
    
    func didTapBuyButton(with product: Product) {
        performSegue(withIdentifier: "showProductDetaill", sender: product)
    }
    func didUpdateQuantity(for product: Product, updatedQuantity: Int) {
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            products[index].quantity = String(updatedQuantity)
        }
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showProductDetaill",
           let destinationVC = segue.destination as? ProductDetailViewController,
           let product = sender as? Product {
            destinationVC.product = product
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
