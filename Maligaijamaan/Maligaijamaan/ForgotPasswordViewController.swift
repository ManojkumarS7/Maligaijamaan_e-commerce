//
//  ForgotPasswordViewController.swift
//  Maligaijamaan
//
//  Created by manoj on 03/08/24.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    
    @IBOutlet weak var mailTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func sumbitButonTapped(_ sender: Any) {
         
         guard let mail = mailTextField.text, !mail.isEmpty else {
             
            
             print("Fill mail fields")
             
             return
         }
         let mailDetails = ["username" : mail]
        
        UserDefaults.standard.set(mail, forKey: "username")
         
         otp(with: mailDetails)
         
     }
     

     
     
     func otp(with details: [String: String]) {
         guard let url = URL(string: "https://maligaijaman.rdegi.com/api/mail.php") else { return }

         var request = URLRequest(url: url)
         request.httpMethod = "POST"
         request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

         let postString = details.compactMap { "\($0.key)=\($0.value)" }.joined(separator: "&")
         request.httpBody = postString.data(using: .utf8)

         let task = URLSession.shared.dataTask(with: request) { data, response, error in
             guard let data = data, error == nil else {
                 DispatchQueue.main.async {
//                     self.showAlert(message: error?.localizedDescription ?? "Unknown error")
                     print("unknown error")
                 }
                 return
             }

             if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                 do {
                     if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                        let message = json["message"] as? String,
                        let otp = json["otp"] as? String {
                       
                             print(json)
//                             self.showAlert(message: message)
                         print(message)
                             print("otp \(otp)")

                             UserDefaults.standard.setValue(otp, forKey: "otp")
                   
                     } else {
                        
//                             self.showAlert(message: "Invalid response format")
                         print("invalid response format")
                
                     }
                 } catch {
                     
//                         self.showAlert(message: "Failed to parse response")
                     print("failed to parse response")
                     
                 }
             } else {
                 DispatchQueue.main.async {
//                     self.showAlert(message: "Signup Failed")
                     print("signup failed")
                 }
             }
         }

         task.resume()
     }
     
//     func showAlert(message: String) {
//         let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//         alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//         present(alert, animated: true, completion: nil)
//     }
 }

    

