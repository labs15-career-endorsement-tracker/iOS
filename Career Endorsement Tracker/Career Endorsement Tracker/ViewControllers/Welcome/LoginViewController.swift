//
//  LoginViewController.swift
//  Career Endorsement Tracker
//
//  Created by Victor  on 8/27/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//
import Foundation
import UIKit

class LoginViewContoller: UIViewController {
    
    let server = Server()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func login() {
        guard let username = emailTextField.text, !username.isEmpty,
            let password = passwordTextField.text, !password.isEmpty
            else {
                Config.showAlert(on: self, style: .alert, title: "Login Error", message: "Please make sure all fields are completed.")
                return
        }
        let user = CurrentUser(email: username, password: password)
        
        server.loginWith(user: user, completion: { (error) in
            if let error = error {
                DispatchQueue.main.async {
                    Config.showAlert(on: self, style: .alert, title: "Login Error", message: error.localizedDescription)
                }
                return
            } else {
                // Save the bearer token to user defaults
           //     let userDefaults = UserDefaults.standard
                let defaults = UserDefaults.standard
                defaults.set(
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
                    self.present(vc, animated: true, completion: nil)
                }
            }
        })
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        login()
    }
    
    func updateViews() {
        // Login Btn
        loginButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = Config.buttonCornerRadius
        //Email TF
        emailTextField.underlined(color: #colorLiteral(red: 0.1592672765, green: 0.432379216, blue: 0.4243381619, alpha: 1))
        //Password TF
        passwordTextField.underlined(color: #colorLiteral(red: 0.737254902, green: 0.1960784314, blue: 0.2, alpha: 1))
    }
    
}
