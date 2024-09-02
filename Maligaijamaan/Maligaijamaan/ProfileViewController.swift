//
//  ProfileViewController.swift
//  Maligaijamaan
//
//  Created by manoj on 03/08/24.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet var userName: UILabel!
    @IBOutlet var userNum: UILabel!
    @IBOutlet var userMail: UILabel!
    
    var user: ProfileData?

    override func viewDidLoad() {
        super.viewDidLoad()
        getProfileData()
    }

    func getProfileData() {
        guard let token = UserDefaults.standard.string(forKey: "jwt"),
              let key = UserDefaults.standard.string(forKey: "key") else {
            print("No token or key found")
            return
        }

        let urlString = "https://maligaijaman.rdegi.com/api/profile.php?jwt=\(token)&secretkey=\(key)"
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
                let userData = try JSONDecoder().decode(ProfileData.self, from: data)
                print(userData)
                
                DispatchQueue.main.async {
                    self?.updateUI(with: userData)
                }
            } catch {
                print("Error decoding data: \(error)")
            }
        }.resume()
    }

    func updateUI(with profileData: ProfileData) {
        userName.text = profileData.name
        userNum.text = profileData.phone
        userMail.text = profileData.username
    }
}

// Define your ProfileData struct here
struct ProfileData: Codable {
    let id: Int
    let username: String
    let name: String
    let phone: String
}
