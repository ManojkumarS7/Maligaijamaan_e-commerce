//
//  OTPViewController.swift
//  Maligaijamaan
//
//  Created by manoj on 03/08/24.
//

import UIKit



class OTPViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var otp1: UITextField!
    
    @IBOutlet var otp2: UITextField!
    
    @IBOutlet var otp3: UITextField!
    
    @IBOutlet var otp4: UITextField!
    
    @IBOutlet var otp5: UITextField!
    
    @IBOutlet var otp6: UITextField!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        otp1.delegate = self
        otp2.delegate = self
        otp3.delegate = self
        otp4.delegate = self
        otp5.delegate = self
        otp6.delegate = self

        otp1.addTarget(self, action: #selector(didFunChange), for: .editingChanged)
        otp2.addTarget(self, action: #selector(didFunChange), for: .editingChanged)
        otp3.addTarget(self, action: #selector(didFunChange), for: .editingChanged)
        otp4.addTarget(self, action: #selector(didFunChange), for: .editingChanged)
        otp5.addTarget(self, action: #selector(didFunChange), for: .editingChanged)
        otp6.addTarget(self, action: #selector(didFunChange), for: .editingChanged)
    }
    
    @objc func didFunChange(textField: UITextField) {
        let text = textField.text
        
        if text?.count == 1 {
            switch textField {
            case otp1: otp2.becomeFirstResponder()
            case otp2: otp3.becomeFirstResponder()
            case otp3: otp4.becomeFirstResponder()
            case otp4: otp5.becomeFirstResponder()
            case otp5: otp6.becomeFirstResponder()
            case otp6: otp6.resignFirstResponder()
            default: return
            }
        }
        
        if text?.count == 0 {
            switch textField {
            case otp1: otp1.becomeFirstResponder()
            case otp2: otp1.becomeFirstResponder()
            case otp3: otp2.becomeFirstResponder()
            case otp4: otp3.becomeFirstResponder()
            case otp5: otp4.becomeFirstResponder()
            case otp6: otp5.becomeFirstResponder()
            default: return
            }
        }
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        let otpPart1 = otp1.text ?? ""
        let otpPart2 = otp2.text ?? ""
        let otpPart3 = otp3.text ?? ""
        let otpPart4 = otp4.text ?? ""
        let otpPart5 = otp5.text ?? ""
        let otpPart6 = otp6.text ?? ""
        
        let enteredOTP = otpPart1 + otpPart2 + otpPart3 + otpPart4 + otpPart5 + otpPart6
        
        print("Entered OTP: \(enteredOTP)")
        
        if let savedOTP = UserDefaults.standard.string(forKey: "savedOTP") {
            print("Saved OTP: \(savedOTP)")
            
            if enteredOTP == savedOTP {
                // OTP matches
                print("OTP is correct")
                // Perform necessary actions on successful OTP verification
                // Example action: show alert
                let alert = UIAlertController(title: "Success", message: "OTP is correct", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                // OTP does not match
                print("OTP is incorrect")
                // Perform necessary actions on failed OTP verification
                // Example action: show alert
                let alert = UIAlertController(title: "Error", message: "OTP is incorrect", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            print("No OTP saved in UserDefaults")
            // Example action: show alert
            let alert = UIAlertController(title: "Error", message: "No OTP saved", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
