//
//  LoginViewController.swift
//  Maligaijamaan
//
//  Created by manoj on 03/08/24.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
               passwordTextField.delegate = self
      
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

         if textField == emailTextField {
             passwordTextField.becomeFirstResponder()
         } else if textField == passwordTextField {
             passwordTextField.resignFirstResponder()
         }
         return true
     }
    
    @IBAction func signupButtonTapped(_ sender: UIButton) {
            guard let email = emailTextField.text, !email.isEmpty,
                  let password = passwordTextField.text, !password.isEmpty else {
     
                showAlert(title: "Error", message: "Fill All Fields")
                return
            }
            
            let signupDetails = ["username": email, "password": password]
            signupUser(signupDetails: signupDetails)
        }

 
    func signupUser(signupDetails: [String: String]) {
        guard let url = URL(string: "https://maligaijaman.rdegi.com/api/loginapi.php") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let bodyComponents = signupDetails.map { key, value in
            return "\(key)=\(value)"
        }
        let bodyString = bodyComponents.joined(separator: "&")
        
        request.httpBody = bodyString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: "Error occurred: \(error.localizedDescription)")
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: "Invalid response or status code")
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: "No data received")
                }
                return
            }
            
            do {

                
                if let responseObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Response object:", responseObject)
                    
                   let jwt = responseObject["jwt"] as? String
                let secretKey = responseObject["secretkey"] as? String
                  
                        let defaults = UserDefaults.standard
                        defaults.set(jwt, forKey: "jwt")
                        defaults.set(secretKey, forKey: "key")
                    
                
            
                 
                        DispatchQueue.main.async {
                            let Message = responseObject["message"] as? String ?? "Invalid email or password."

                            
                            if Message == "Login successful" {
                               
                                self.performSegue(withIdentifier: "HomeViewController", sender: self)
                            } else {
                                self.showAlert(title: "Error", message: Message)
                            }
                            
                        }
                    }
                else {
                    DispatchQueue.main.async {
                        print("Unexpected response format")
                        self.showAlert(title: "Error", message: "Unexpected response format")
                    }
                }
            } catch let jsonError {
                DispatchQueue.main.async {
                    print("Failed to decode JSON:", jsonError.localizedDescription)
                    self.showAlert(title: "Error", message: "Failed to decode JSON: \(jsonError.localizedDescription)")
                }
            }
        }
        task.resume()
    }


    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

    
}
