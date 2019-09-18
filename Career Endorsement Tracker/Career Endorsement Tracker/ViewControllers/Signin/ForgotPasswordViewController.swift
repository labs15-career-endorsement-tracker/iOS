//
//  ForgotPasswordViewController.swift
//  Career Endorsement Tracker
//
//  Created by Sameera Leola on 9/18/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    // MARK: - Properties
    let server = Server()
    
    // MARK: - Outlets
    @IBOutlet weak var emailAddressField: UITextField!
    
    
    // MARK: - View states
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions
    @IBAction func requestPasswordTapped(_ sender: Any) {
        // Make sure they entered an email address
        guard let username = emailAddressField.text, !username.isEmpty else {
            Config.showAlert(on: self, style: .alert, title: "Forgot password", message: "You must enter the email address you used when you signed up.")
            return
        }
        
        // There is an email address lets request the reset
        let user = ResetPassword(email: username)
        
        server.resetPasswordFor(user: user, completion: { (error) in
            if let error = error {
                DispatchQueue.main.async {
                    Config.showAlert(on: self, style: .alert, title: "Error resetting password", message: error.localizedDescription)
                }
                return
            } else {
                // Pop back to main for now
                DispatchQueue.main.async {
                    
                    self.dismiss(animated: true, completion: nil)
                }
            }
        })
    }
    
    @IBAction func cancelRequestTapped(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Functions


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
