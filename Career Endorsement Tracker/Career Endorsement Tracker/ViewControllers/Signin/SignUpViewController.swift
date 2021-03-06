//
//  SignUpViewController.swift
//  Career Endorsement Tracker
//
//  Created by Victor  on 8/27/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import UIKit

class SignUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: - Instances

    let server = Server()
    let lambdaTracks: [String] = ["Select your track", "Full-Stack Web", "iOS", "Data Science", "Android", "UX Design"]
    
    // Form fields
    var track_id: Int = 0

    // MARK: - Outlets
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var trackTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the picker view for the track selection
        let trackPicker = UIPickerView()
        trackTextField.inputView = trackPicker
        trackPicker.delegate = self
        updateViews()
    }
    
    
    // MARK: - Actions
    @IBAction func registerButtonPressed(_ sender: Any) {
        signUp()
    }
    
    
    // MARK: - Pickerview
    // Picker view for track selection
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return lambdaTracks.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return lambdaTracks[row]
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        trackTextField.text = lambdaTracks[row]
        track_id = row
    }

    
    // MARK: - Signup
    func signUp() {
        // Validate the user input
        
        guard let firstName = firstNameTextField.text, !firstName.isEmpty, isValidName(nameStr: firstName) else {
            Config.showAlert(on: self, style: .alert, title: "Sign Up Error", message: "Valid first name needed for sign up.")
            return
        }
        guard let lastName = lastNameTextField.text, !lastName.isEmpty, isValidName(nameStr: lastName) else {
            Config.showAlert(on: self, style: .alert, title: "Sign Up Error", message: "Valid last name needed for sign up.")
            return
        }
        guard let email = emailTextField.text, !email.isEmpty, isValidEmail(emailStr: email) else {
            Config.showAlert(on: self, style: .alert, title: "Sign Up Error", message: "Valid email needed for sign up.")
            return
        }
        guard let password = passwordTextField.text, password.count >= 8 else {
            Config.showAlert(on: self, style: .alert, title: "Sign Up Error", message: "Valid password needed for sign up. 8 characters or more.")
            return
        }
        guard let confirmation = confirmPasswordTextField.text, confirmation == password else {
            Config.showAlert(on: self, style: .alert, title: "Sign Up Error", message: "Passwords do not match. Please try again.")
            return
        }
        
        if !isValidTrack() {
            Config.showAlert(on: self, style: .alert, title: "Sign Up Error", message: "Valid track is needed for sign up.")
            return
        }
        
            // The input values are validated, send the sign up request to the server.
        server.signUpWith(firstName: firstName, lastName: lastName, email: email, password: password, trackID: track_id, completion: { (error) in
                if let error = error  {
                    print(error)
                    DispatchQueue.main.async {
                        Config.showAlert(on: self, style: .alert, title: "Sign Up Error", message: error.localizedDescription)
                    }
                    return
                } else {
                    // Save the encoded and decoded bearer tokens to user defaults
                    let defaults = UserDefaults.standard
                    defaults.set(true, forKey: "isLoggedIn")
                    DispatchQueue.main.async {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
                    }
                }
                
            })
    }
    
    // MARK: - UI
    func updateViews() {
        registerButton.layer.masksToBounds = true
        registerButton.layer.cornerRadius = Config.buttonCornerRadius
    }
    
    
    // MARK: Validation Functions and Actions
    
        // Validate a name
        func isValidName(nameStr:String) -> Bool {
            let nameRegEx = "^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$"
            let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
            return nameTest.evaluate(with: nameStr)
        }
        
        //Validate email
        func isValidEmail(emailStr:String) -> Bool {
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: emailStr)
        }
        
        // Validate password of 8-16 characters
        func isValidPassword(passwordStr:String) -> Bool {
            let passwordRegEx = "^.*(?=.{8,16})(?=.*[A-Z])(?=.*[a-zA-Z])(?=.*\\d)|(?=.*[!@#$&*]).*$"
            return  NSPredicate(format:"SELF MATCHES %@", passwordRegEx).evaluate(with: passwordStr)
        }
    
        // Validate track
        func isValidTrack() -> Bool {
            if( (1...5).contains(track_id) ) {
                trackTextField.resignFirstResponder()
                return true
            } else {
                print("Bad trackID")
                return false
            }
        }
}
    
