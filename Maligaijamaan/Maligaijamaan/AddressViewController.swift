//
//  AddressViewController.swift
//  Maligaijamaan
//
//  Created by manoj on 03/08/24.
//

import UIKit

class AddressViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var phnNumberTextField: UITextField!
    @IBOutlet var stateTextField: UITextField!
    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var doorNoTextField: UITextField!
    @IBOutlet var StreetVillageTextFeild: UITextField!
    @IBOutlet var pincodeTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        phnNumberTextField.delegate = self
        stateTextField.delegate = self
        cityTextField.delegate = self
        doorNoTextField.delegate = self
        StreetVillageTextFeild.delegate = self
        pincodeTextField.delegate = self
        
        getAddress()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func getAddress() {
        guard let token = UserDefaults.standard.string(forKey: "jwt"),
              let key = UserDefaults.standard.string(forKey: "key") else {
            print("No token or key found")
            return
        }

        let urlString = "https://maligaijaman.rdegi.com/api/addressget.php?jwt=\(token)&secretkey=\(key)"
        print(urlString)

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            // Log the raw response data
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw response data: \(jsonString)")
            } else {
                print("Unable to convert data to string")
            }

            do {
                let userData = try JSONDecoder().decode([UserAddress].self, from: data)
                print(userData)
                
                // Assuming you want to update the UI with the first address in the list
                if let firstAddress = userData.first {
                    DispatchQueue.main.async {
                        self?.updateUI(with: firstAddress)
                    }
                }
                
            } catch {
                print("Error decoding data: \(error)")
            }
        }.resume()
    }
    
    func updateUI(with address: UserAddress) {
        nameTextField.text = address.name
        phnNumberTextField.text = address.phonenumber
        stateTextField.text = address.state
        cityTextField.text = address.city
        doorNoTextField.text = address.door_no
        StreetVillageTextFeild.text = address.street_village
        pincodeTextField.text = address.pincode
    }
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        
        func postProduct() {
            // Retrieve token and key from UserDefaults
            guard let token = UserDefaults.standard.string(forKey: "jwt"),
                  let key = UserDefaults.standard.string(forKey: "key") else {
                print("No token or key found")
                return
            }
            
            let parameter: [String: Any] = [
              

                "name" : nameTextField.text!,
                "phonenumber" : phnNumberTextField.text!,
                "state" : stateTextField.text!,
                "city" : cityTextField.text!,
                "door_no" : doorNoTextField.text!,
                "street_village" : StreetVillageTextFeild.text!,
                "pincode" : pincodeTextField.text!
            ]
            

            let urlString = "https://maligaijaman.rdegi.com/api/addressinsert.php"
            
            let session = URLSession.shared
            
      
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
    
    
    
}

struct UserAddress: Codable {
    let id: String
    let user_id: String?
    let name: String
    let phonenumber: String
    let state: String
    let city: String
    let door_no: String
    let street_village: String
    let pincode: String
}
