//
//  SignupViewController.swift
//  Maligaijamaan
//
//  Created by manoj on 03/08/24.
//

import UIKit

class SignupViewController: UIViewController {
    
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var phnnoTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    
    
    func isValidEmail(_ email: String) -> Bool {
           let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
           let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
           return emailPredicate.evaluate(with: email)
       }
       
       func isValidPhnno(_ phoneNumber: String) -> Bool {
           let phnregex = "[0-9]{10}"
           let phonepredicate = NSPredicate(format: "SELF MATCHES %@", phnregex)
           return phonepredicate.evaluate(with: phoneNumber)
       }
       
       @IBAction func signupButtonTapped(_ sender: Any) {
           guard let username = nameTextField.text, !username.isEmpty,
                 let email = emailTextField.text, !email.isEmpty,
                 let password = passwordTextField.text, !password.isEmpty,
                 let phone = phnnoTextField.text, !phone.isEmpty else {
               showAlert(title: "Error", message: "Fill All The Forms")
               return
           }
           
           guard isValidEmail(email) else {
               showAlert(title: "Error", message: "Invalid Email")
               return
           }
           
           let parameters: [String: Any] = [
               "username": email,
               "password": password,
               "phone": phone,
               "name": username
           ]

           guard let url = URL(string: "https://maligaijaman.rdegi.com/api/signupapi.php") else { return }
           
//           var request = URLRequest(url: url)
//           request.httpMethod = "POST"
//           request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//           print("Request Parameters: \(parameters)")
//           
//           do {
//               request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
//         
//           } catch let error {
//               print("Error encoding parameters: \(error.localizedDescription)")
//               return
//           }
//           
//           let task = URLSession.shared.dataTask(with: request) { data, response, error in
//               if let error = error {
//                   print("Error: \(error.localizedDescription)")
//                   DispatchQueue.main.async {
//                       self.showAlert(title: "Error", message: "Failed to sign up")
//                   }
//                   return
//               }
//               
//               guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
//                   if let httpResponse = response as? HTTPURLResponse {
//                       print("Invalid response from the server. Status code: \(httpResponse.statusCode)")
//                       if let data = data, let errorResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                           if let errorMessage = errorResponse["message"] as? String {
//                               print("Error message from server: \(errorMessage)")
//                           }
//                       }
//                   }
//                   return
//               }
//               
//               guard let data = data else {
//                   DispatchQueue.main.async {
//                       self.showAlert(title: "Error", message: "No data received")
//                   }
//                   return
//               }
//               
//               do {
//                   if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//                      let message = json["message"] as? String {
//                       DispatchQueue.main.async {
//                           if message == "User registered successfully" {
//                               self.performSegue(withIdentifier: "HomeViewController", sender: self)
//                           } else {
//                               self.showAlert(title: "Alert", message: message)
//                               print(message)
//                           }
//                       }
//                   }
//               } catch let error {
//                   print("Error decoding response: \(error.localizedDescription)")
//                   DispatchQueue.main.async {
//                       self.showAlert(title: "Error", message: "Failed to sign up")
//                   }
//               }
//           }
//           
//           task.resume()
           let session = URLSession.shared
           
           // Create the URL
//           guard let url = URL(string: urlString) else {
//               print("Invalid URL")
//               return
//           }
           
           var request = URLRequest(url: url)
           request.httpMethod = "POST"
           
           let boundary = UUID().uuidString
           request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
           
           let body = createFormBody(with: parameters, boundary: boundary)
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
                       self.navigateToNextPage()
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
       
       
       func navigateToNextPage() {
           if let nextViewController = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") {
               nextViewController.modalPresentationStyle = .fullScreen
               present(nextViewController, animated: true, completion: nil)
           }
       }
       
       private func showAlert(title: String, message: String) {
           let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           present(alert, animated: true, completion: nil)
       }
   
}
