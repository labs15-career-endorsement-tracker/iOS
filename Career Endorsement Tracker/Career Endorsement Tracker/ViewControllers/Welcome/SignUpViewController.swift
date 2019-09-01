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
    let lambdaTracks: [String] = [ "Full-Stack Web", "iOS", "Data Science", "Android", "UX Design"]
    
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
    @IBOutlet weak var validatePasswordTextField: UITextField!
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
    
    
    
    // MARK: Text Field Validation Actions
    // first name
    @IBAction func firstNameTextFieldChanged(_ sender: UITextField) {
        lastNameTextField.isEnabled = true
    }
    
    // last name
    @IBAction func lasttNameTextFieldChanged(_ sender: UITextField) {
        emailTextField.isEnabled = true
    }
    
    
    
    
    
    
    // email address
    @IBAction func emailTextFieldChanged(_ sender: UITextField) {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let isValidEmail = emailTest.evaluate(with: emailTextField.text)
        if (isValidEmail) {
            passwordTextField.isEnabled = true
            validatePasswordTextField.isEnabled = true
        } else {
            lastNameTextField.becomeFirstResponder()
            Config.showAlert(on: self, style: .alert, title: "SignUp Error", message: "Please enter a valid email address.")
            emailTextField.text = nil
        }
    }
    
    // password
    // TODO: Validate passwords
    
    @IBAction func first_nameDidEndOnExit(_ sender: UITextField) {
        print("first_nameDidEndOnExit")
        let charCount = firstNameTextField.text?.count ?? 0
        if (charCount < 8) {
            print("first_Name TextField.text?.count = \(charCount)")
            self.becomeFirstResponder()
        }
    }
    @IBAction func fnEditingDidEnd(_ sender: UITextField) {
        print("irst_nameEditingDidEnd")
        let charCount = firstNameTextField.text?.count ?? 0
        
        if (charCount < 8) {
            print("first_Name TextField.text?.count = \(charCount)")
            self.becomeFirstResponder()
        }
    }
    @IBAction func trackSelected(_ sender: UITextField) {
        let selectedTrack = trackTextField.text
        switch(selectedTrack) {
        case "Full-Stack Web":
            trackID = 1
        case "iOS":
            trackID = 2
        case "Data Science":
            trackID = 3
        case "Android":
            trackID = 4
        case "UX Design":
            trackID = 5
        default:
            Config.showAlert(on: self, style: .alert, title: "SignUp Error", message:  "Please select a track")
        }
    }
    
    
    
    
    // MARK: - Signup
    
    func signUp() {
        
        // Validation actions for text fields
//
//        guard let firstName = firstNameTextField.text, !firstName.isEmpty, let lastName = lastNameTextField.text, !lastName.isEmpty, !lastName.isEmpty, track = trackID, track != -1, let username = emailTextField.text, !username.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
//            Config.showAlert(on: self, style: .alert, title: "SignUp Error", message: "Please make sure all fields are completed.")
//            return
//        }
        guard let firstName = firstNameTextField.text, !firstName.isEmpty,
                let lastName = lastNameTextField.text,  !lastName.isEmpty,
                let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextField.text, !password.isEmpty else {
                Config.showAlert(on: self, style: .alert, title: "SignUp Error", message: "Please make sure all fields are completed.")
                return
        }
    
        let device_token = UserDefaults.standard.string(forKey: UserDefaultsKeys.deviceToken) ?? ""
            
        let user = CurrentUser(first_name: firstName, last_name: lastName, email: email, password: password, tracks_id: trackID, device_token: device_token)
    
//        let user = CurrentUser(first_name: firstName, last_name: lastName, email: email, password: password, tracks_id: trackID)
        
        server.signUp(with: user) { (error) in
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
    
    // MARK: - UI
    
    func updateViews() {
        registerButton.layer.masksToBounds = true
        registerButton.layer.cornerRadius = Config.buttonCornerRadius
    }
    
    
    // MARK: Validation Functions and Actions

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
