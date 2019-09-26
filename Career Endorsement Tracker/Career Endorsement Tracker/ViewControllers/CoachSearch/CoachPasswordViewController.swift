//
//  CoachPasswordViewController.swift
//  Career Endorsement Tracker
//
//  Created by Alex on 9/24/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class CoachPasswordViewController: UIViewController {
    
    // MARK: - Properties
    let server = Server()
    var emailAddress: String?
    
    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
  
    
    // MARK: - View states
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.becomeFirstResponder()
    }
    

    // MARK: - Actions
    
    @IBAction func requestPasswordTapped(_ sender: Any) {
        // Make sure they entered an email address
        guard let username = emailTextField.text, !username.isEmpty else {
            Config.showAlert(on: self, style: .alert, title: "Forgot password", message: "You must enter the email address you used when you signed up.")
            return
        }
        
        // There is an email address lets request the reset
        let user = ResetPassword(email: username)
        
        server.resetPasswordFor(user: user, completion: { (error) in
            if let error = error {
                DispatchQueue.main.async {
                    self.displayAlert(message: error.localizedDescription, title: "Error resetting password")
                }
                return
            } else {
                // Pop back to main for now
                DispatchQueue.main.async {
                    self.displayAlert(message: "Please check your email.", title: "Password Reset")
                }
            }
        })
    }
        
        
    // MARK: - Functions
    func displayAlert(message: String, title: String){
        // Create the alert controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { UIAlertAction in
            NSLog("OK Pressed")
            self.dismiss(animated: true, completion: nil)
        }
        
        // Add the actions
        alertController.addAction(okAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
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
