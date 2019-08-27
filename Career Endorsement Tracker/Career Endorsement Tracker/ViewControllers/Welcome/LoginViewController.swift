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
        let user = CurrentUser(username: username, password: password)
        
        server.loginWith(user: user, completion: { (error) in
            if let error = error {
                DispatchQueue.main.async {
                    Config.showAlert(on: self, style: .alert, title: "Login Error", message: error.localizedDescription)
                }
                return
            } else {
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
        loginButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = Config.buttonCornerRadius
    }
    
}
