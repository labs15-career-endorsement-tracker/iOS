//
//  LoginViewController.swift
//  Career Endorsement Tracker
//
//  Created by Victor  on 8/27/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//
import Foundation
import UIKit

protocol ForgotPasswordDelegate {
    func dismissModalView()
}

class LoginViewContoller: UIViewController, UITextFieldDelegate {
    
    // MARK: - Instances
    
    let server = Server()
    var dismissModalDelegate: ForgotPasswordDelegate!
    
    // MARK: - Outlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - Actions
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        login()
    }
    
    @IBAction func resetPasswordPressed(_ sender: Any) {
        
    }
    
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        passwordTextField.delegate = self
    }
    
    // MARK: - Methods
    
    func login() {
        guard let username = emailTextField.text, !username.isEmpty,
            let password = passwordTextField.text, !password.isEmpty
            else {
                Config.showAlert(on: self, style: .alert, title: "Login Error", message: "Please make sure all fields are completed.")
                return
        }
        let user = LoggedInUser(email: username, password: password)
        
        server.loginWith(user: user, completion: { (error) in
            if let error = error {
                DispatchQueue.main.async {
                    Config.showAlert(on: self, style: .alert, title: "Login Error", message: error.localizedDescription)
                }
                return
            } else {
                // Save the encoded and decoded bearer tokens to user defaults
                let defaults = UserDefaults.standard
                defaults.set(self.server.encodedBearer, forKey: UserDefaultsKeys.encodedBearer)
                defaults.set(true, forKey: UserDefaultsKeys.ifUserLoggedIn)
                
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
                    self.present(vc, animated: true, completion: nil)
                }
            }
        })
    }
    
    func updateViews() {
        loginButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = Config.buttonCornerRadius
        //Email TF
        emailTextField.underlined(color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
        //Password TF
        passwordTextField.underlined(color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        login()
        return true
    }
    
     // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? ForgotPasswordViewController else { return }
        destinationVC.emailAddress = emailTextField.text
    }
}

extension LoginViewContoller: ForgotPasswordDelegate {
    func dismissModalView() {
        Config.showAlert(on: self, style: .alert, title: "Reset password", message: "Please check your email to complete password reset.")
    }
}
