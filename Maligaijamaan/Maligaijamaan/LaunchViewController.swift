//
//  LaunchViewController.swift
//  Maligaijamaan
//
//  Created by manoj on 04/08/24.
//

import UIKit

class LaunchViewController: UIViewController {
    
    
    @IBOutlet weak var launchLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        launchLogo.layer.cornerRadius = launchLogo.frame.size.height / 2.5
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
