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
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var password: String = ""
    var confirmationPassword: String = ""
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        colorTextfield(fieldName: firstNameTextField)
  //      firstNameTextField.becomeFirstResponder()
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
        if !validiateAllInput() {
            Config.showAlert(on: self, style: .alert, title: "Sign Up Error", message: "Please make sure all fields are valid and completed.")
        } else {
            let user = CurrentUser(first_name: firstName, last_name: lastName, email: email, password: password, tracks_id: track_id)
            
            // The input values are validated, send the sign up request to the server.
            server.signUp(with: user, completion: { (error) in
                if let error = error  {
                    print(error)
                    DispatchQueue.main.async {
                        Config.showAlert(on: self, style: .alert, title: "Sign Up Error", message: error.localizedDescription)
                    }
                    return
                } else {
                    // Save the encoded and decoded bearer tokens to user defaults
                    let defaults = UserDefaults.standard
                    defaults.set(self.server.encodedBearer, forKey: UserDefaultsKeys.encodedBearer)
                    
                    DispatchQueue.main.async {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
                        self.present(vc, animated: true, completion: nil)
                    }
                }
                
            })
        } // end else
        
    }
    
    // MARK: - UI
    func updateViews() {
        registerButton.layer.masksToBounds = true
        registerButton.layer.cornerRadius = Config.buttonCornerRadius
    }
    
    
    // MARK: Validation Functions and Actions
    
    // Final validation before sending data to server
        func validiateAllInput() -> Bool {
            if isValidName(nameStr: firstName),
                isValidName(nameStr: lastName),
                isValidEmail(emailStr: email),
                isValidPassword(passwordStr: password),
                confirmPassword(confirmPasswordStr: confirmationPassword),
                isValidTrack() {
                return true
            } else {
                return false
            }
        }
        
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
        
        // Confirm password
        func confirmPassword(confirmPasswordStr:String) -> Bool {
            return  NSPredicate(format:"SELF MATCHES %@", password).evaluate(with: confirmPasswordStr)
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
    
    // MARK: - Textfield Delegation Extension
    extension SignUpViewController: UITextFieldDelegate {
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            // Validate first name
            if textField == firstNameTextField {
                if let firstName = firstNameTextField.text, isValidName(nameStr: firstName) {
                    self.firstName = firstName
                    resetColors(fieldName: firstNameTextField)
                    colorTextfield(fieldName: lastNameTextField)
                    lastNameTextField.becomeFirstResponder()
                    return true
                } else {
                    Config.showAlert(on: self, style: .alert, title: "SignUp Error", message: "Please enter a valid first name.")
                }
            } // End validate lastName
                
                // Validate last name
            else if textField == lastNameTextField {
                if let lastName = lastNameTextField.text, isValidName(nameStr: lastName) {
                    self.lastName = lastName
                    resetColors(fieldName: lastNameTextField)
                    colorTextfield(fieldName: emailTextField)
                    emailTextField.becomeFirstResponder()
                    return true
                } else {
                    Config.showAlert(on: self, style: .alert, title: "SignUp Error", message: "Please enter a valid last name.")
                }
            } // End validate lastName
                
                // Validate email
            else if textField == emailTextField {
                if let email = emailTextField.text, isValidEmail(emailStr: email) {
                    self.email = email
                    resetColors(fieldName: emailTextField)
                    colorTextfield(fieldName: passwordTextField)
                    passwordTextField.becomeFirstResponder()
                    return true
                } else {
                    //     emailTextField.layer.borderColor = Config.textFieldBorderColor
                    Config.showAlert(on: self, style: .alert, title: "SignUp Error", message: "Please enter a valid email address.")
                }
            } // End validate email
                
                // Validate password
            else if textField == passwordTextField {
                if let password = passwordTextField.text,  isValidPassword(passwordStr: password) {
                    self.password = password
                    resetColors(fieldName: passwordTextField)
                    colorTextfield(fieldName: confirmPasswordTextField)
                    confirmPasswordTextField.becomeFirstResponder()
                    return true
                } else {
                    passwordTextField.text = nil
                    Config.showAlert(on: self, style: .alert, title: "SignUp Error", message: " Password must be 8-16 characters, with at least one capital, numeric or special character")
                }
            } // End validate email
                
                // Validate confirm password
            else if textField == confirmPasswordTextField {
                if let confirmationPassword = confirmPasswordTextField.text, confirmPassword(confirmPasswordStr: confirmationPassword)  {
                    self.confirmationPassword = confirmationPassword
                    resetColors(fieldName: confirmPasswordTextField)
                    colorTextfield(fieldName: trackTextField)
                    trackTextField.becomeFirstResponder()
                    return true
                } else {
                    passwordTextField.text = nil
                    confirmPasswordTextField.text = nil
                    passwordTextField.becomeFirstResponder()
                    colorTextfield(fieldName: passwordTextField)
                    resetColors(fieldName: confirmPasswordTextField)
                    Config.showAlert(on: self, style: .alert, title: "SignUp Error", message: "Passwords do not match.")
                    
                }
            }  // End validate confirm password
            
            return false  // There were problems with one or more fields
        }
        
        // Highlight
        func colorTextfield(fieldName: UITextField) {
            fieldName.layer.borderWidth = 1
            fieldName.layer.cornerRadius = 5.0
            fieldName.layer.borderColor = Config.textFieldBorderColor
        }
        
        func resetColors(fieldName: UITextField) {
            fieldName.layer.borderWidth = 0
            fieldName.layer.borderColor = UIColor.lightGray.cgColor
        }
        
} // End Textfield Delegation Extension
