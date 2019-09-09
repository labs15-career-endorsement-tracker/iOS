//
//  WelcomeViewController.swift
//  Career Endorsement Tracker
//
//  Created by Victor  on 8/27/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false;
    }
    
    func updateViews() {
        self.navigationController?.navigationBar.isHidden = true;
        self.navigationController?.navigationBar.tintColor = Config.buttonTitleColor
       //
        loginButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = Config.buttonCornerRadius
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = Config.themeGreen.cgColor
       //
        signUpButton.layer.borderWidth = 2
        signUpButton.layer.borderColor = UIColor.black.cgColor
        signUpButton.layer.masksToBounds = true
        signUpButton.layer.cornerRadius = Config.buttonCornerRadius
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "Login", sender: self)
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "SignUp", sender: self)
    }
    
}
