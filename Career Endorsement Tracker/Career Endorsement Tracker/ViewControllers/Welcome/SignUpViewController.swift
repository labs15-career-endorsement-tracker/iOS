//
//  SignUpViewController.swift
//  Career Endorsement Tracker
//
//  Created by Victor  on 8/27/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import UIKit

class SignUpViewController: UIViewController {
    
    let server = Server()
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var trackTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func signUp() {
        
        guard let firstName = firstNameTextField.text, !firstName.isEmpty, let lastName = lastNameTextField.text, !lastName.isEmpty, !lastName.isEmpty, let track = trackTextField.text, !track.isEmpty, let username = emailTextField.text, !username.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            Config.showAlert(on: self, style: .alert, title: "SignUp Error", message: "Please make sure all fields are completed.")
            return
        }
        
        let user = CurrentUser(username: username, password: password)
        
        server.loginWith(user: user) { (error) in
            if let error = error  {
                DispatchQueue.main.async {
                    Config.showAlert(on: self, style: .alert, title: "Sign Up Error", message: error.localizedDescription)
                }
                return
            } else {
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
                    self.present(vc, animated: true, completion: nil)
                }
            }
            
        }
        
    }
    
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        signUp()
    }
    
    func updateViews() {
        registerButton.layer.masksToBounds = true
        registerButton.layer.cornerRadius = Config.buttonCornerRadius
    }
    
    
    //MARK: Validation
    
    //name check
    func isValidName(testStr:String) -> Bool {
        let nameRegEx = "^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$"
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return nameTest.evaluate(with: testStr)
    }
    
    //email check
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
}
