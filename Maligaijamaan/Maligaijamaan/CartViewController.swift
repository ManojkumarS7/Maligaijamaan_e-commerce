//
//  CartViewController.swift
//  Maligaijamaan
//
//  Created by manoj on 03/08/24.
//

import UIKit

import UIKit

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CartViewDelegate {
  
    @IBOutlet var cartTable: UITableView!
    @IBOutlet var cartTotalPrice: UILabel!
    
    var cart = [CartData]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cartTable.delegate = self
        cartTable.dataSource = self

        fetchProducts()
    }
    
    func fetchProducts() {
        guard let token = UserDefaults.standard.string(forKey: "jwt"),
              let key = UserDefaults.standard.string(forKey: "key") else {
            print("No token or key found")
            return
        }
        
        let urlString = "https://maligaijaman.rdegi.com/api/cart.php?jwt=\(token)&secretkey=\(key)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Failed to fetch products:", error)
                return
            }
            
            guard let data = data else { return }
            
            // Print raw JSON data for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("JSON Response: \(jsonString)")
            }
            
            do {
                let carts = try JSONDecoder().decode([CartData].self, from: data)
                DispatchQueue.main.async {
                    self.cart = carts
                    self.cartTable.reloadData()
                    self.updateTotalPrice()
                }
            } catch let jsonError {
                print("Failed to decode JSON:", jsonError)
            }
        }.resume()
    }
    
    func updateTotalPrice() {
        let totalPrice = cart.reduce(0) { (result, cartData) -> Double in
            if let price = Double(cartData.product_price) {
                return result + price
            }
            return result
        }
        
        cartTotalPrice.text = String(format: "%.2f", totalPrice)
    }
    
    func postProduct(with product: CartData) {
        let parameters: [String: String] = [
            "id": product.id
        ]
        
        let urlString = "https://maligaijaman.rdegi.com/api/deletecart.php"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let body = createFormBody(with: parameters, boundary: boundary)
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response from the server")
                return
            }
            
            guard let responseData = data else {
                print("Nil data received from the server")
                return
            }
            
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as? [String: Any] {
                    print(jsonResponse)
                } else {
                    print("Data might be in wrong format")
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
    
    func didRemoveButtonTapped(with cart: CartData) {
        postProduct(with: cart)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTable.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartTableViewCell
        
        let cartData = cart[indexPath.row]
        cell.cartName.text = cartData.product_name
        cell.cartPrice.text = cartData.product_price
        cell.removeCart = cartData
        cell.delegate = self
        
        if let imageUrl = URL(string: cartData.img_path) {
            URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                if let error = error {
                    print("Failed to fetch image", error)
                    return
                }
                
                guard let data = data else { return }
                DispatchQueue.main.async {
                    cell.cartImage.image = UIImage(data: data)
                }
            }.resume()
        }
        
        return cell
    }
    
    @IBAction func checkOurTapped(_ sender: Any) {

        for cartItem in cart {
                postProduct(with: cartItem)
            }
        
        performSegue(withIdentifier: "AddressView", sender: self)
        
    }
    
    func postProducts(cartItems: [CartData]) {
        
        
        guard let token = UserDefaults.standard.string(forKey: "jwt"),
              let key = UserDefaults.standard.string(forKey: "key") else {
            print("No token or key found")
            return
        }
        var parameters: [[String: String]] = []
        
        for product in cartItems {
            let productParams: [String: String] = [
                "jwt": token,
                "secretkey" : key
                // add any other parameters as needed
            ]
            parameters.append(productParams)
        }

        let urlString = "https://maligaijaman.rdegi.com/api/conformorder.php"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let body = createBulkFormBody(with: parameters, boundary: boundary)
        request.httpBody = body

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response from the server")
                return
            }

            guard let responseData = data else {
                print("Nil data received from the server")
                return
            }

            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as? [String: Any] {
                    print(jsonResponse)
                } else {
                    print("Data might be in wrong format")
                    throw URLError(.badServerResponse)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }

        task.resume()
    }

    func createBulkFormBody(with parametersArray: [[String: String]], boundary: String) -> Data {
        var body = Data()

        for parameters in parametersArray {
            for (key, value) in parameters {
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                body.append("\(value)\r\n".data(using: .utf8)!)
            }
        }

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        return body
    }

    
    
}
