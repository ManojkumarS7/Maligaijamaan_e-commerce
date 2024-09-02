//
//  ConformOrderViewController.swift
//  Maligaijamaan
//
//  Created by mano on 12/08/24.
//

import UIKit

class ConformOrderViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
//        let name = UserDefaults.standard.string(forKey: "name")
//        let id = UserDefaults.standard.string(forKey: "id")
//        let price = UserDefaults.standard.string(forKey: "proce")
//        let qty = UserDefaults.standard.string(forKey: "qty")
   
        
    }
    
    
    @IBAction func orderConfirmTapped(_ sender: Any) {
        
        let name = UserDefaults.standard.string(forKey: "name")
        let id = UserDefaults.standard.string(forKey: "id")
        let price = UserDefaults.standard.string(forKey: "proce")
        let qty = UserDefaults.standard.string(forKey: "qty")
        
        
        guard let jwt = UserDefaults.standard.string(forKey: "jwt"),
              let key = UserDefaults.standard.string(forKey: "key")
        else {
            print("JWT, key or product details are missing")
            return
        }
        
        let productDetails = [
            "jwt": jwt,
            "secretkey": key,
            "productid": id,
            "productname": name,
            "productprice": "\(price)",
            "qty": qty
        ]
        
        confirmOrder(with: productDetails)
    }

    func confirmOrder(with productDetails: [String: Any]) {
        let urlString = "https://maligaijaman.rdegi.com/api/conformorderinsert.php"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let body = createFormBody(with: productDetails, boundary: boundary)
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

    func createFormBody(with parameters: [String: Any], boundary: String) -> Data {
        var body = Data()
        
        for (key, value) in parameters {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        return body
    }

}
