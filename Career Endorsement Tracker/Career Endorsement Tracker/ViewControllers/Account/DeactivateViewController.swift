//
//  DeactivateViewController.swift
//  Career Endorsement Tracker
//
//  Created by Victor  on 9/27/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import UIKit

class DeactivateViewController: UIViewController {
    @IBOutlet weak var deactivateButton: UIButton!
    let server = Server()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func deactivateButtonPressed(_ sender: Any) {
        guard let token = UserDefaults.standard.object(forKey: "token") as? String else {
            return Config.showAlert(on: self, style: .alert, title: "User could not be authenticated.", message: "Please logout and sign in again.")
        }
        let deactivateAction = UIAlertAction(title: "Deactivate", style: .destructive) {
            (action) in
            UserDefaults.standard.removeObject(forKey: "token")
            UserDefaults.standard.removeObject(forKey: "id")
            UserDefaults.standard.removeObject(forKey: "firstName")
            UserDefaults.standard.removeObject(forKey: "isAdmin")
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            
            self.server.deleteUser(withToken: token) { (error) in
                if let error = error {
                    DispatchQueue.main.async {
                        return Config.showAlert(on: self, style: .alert, title: "Error with Deactivation", message: error.localizedDescription)
                    }
                } else {
                    DispatchQueue.main.async {
                        let storyboard = UIStoryboard(name: "Welcome", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "WelcomeNavigationController")
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        Config.showAlert(on: self, style: .actionSheet, title: nil, message: nil, actions: [deactivateAction, cancelAction], completion: nil)
        
    }
}
