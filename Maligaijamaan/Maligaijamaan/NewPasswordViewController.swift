//
//  NewPasswordViewController.swift
//  Maligaijamaan
//
//  Created by manoj on 03/08/24.
//

import UIKit

class NewPasswordViewController: UIViewController {
    
    @IBOutlet weak var newPassword: UITextField!
    
    @IBOutlet weak var ConfirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
  
       
    }
    
    @IBAction func SubmitButtonTapped(_ sender: Any) {
        
        
        guard let newPass = newPassword.text, newPass.isEmpty,
              let confrimPass = ConfirmPassword.text, confrimPass.isEmpty else {
            
            print("fill all text fields")
            
            return
        }
        
        
        guard newPass == confrimPass else {
            
            print("Password does not match")
            
            return
        }
        
        let mail = UserDefaults.standard.string(forKey: "username")
        
        let mailDetails = ["username" : mail,"password" : confrimPass]
        
        password(with: mailDetails as [String : Any])
        
    }
    
    func password(with details: [String: Any]) {
        guard let url = URL(string: "https://maligaijaman.rdegi.com/api/forgetpassword.php") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let postString = details.compactMap { "\($0.key)=\($0.value)" }.joined(separator: "&")
        request.httpBody = postString.data(using: .utf8)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self.showAlert(title: "Message", message: error?.localizedDescription ?? "Unknown error")
                    print("unknown error")
                }
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let message = json["message"] as? String
                                                   {
                      
                            print(json)
                        self.showAlert(title: "Message", message: message)
                        print(message)
           
                  
                    } else {
                       
                        self.showAlert(title: "Message", message: "Invalid response format")
                        print("invalid response format")
               
                    }
                } catch {
                    
                    self.showAlert(title: "Message", message: "Failed to parse response")
                    print("failed to parse response")
                    
                }
            } else {
                DispatchQueue.main.async {

                    print("signup failed")
                }
            }
        }

        task.resume()
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
