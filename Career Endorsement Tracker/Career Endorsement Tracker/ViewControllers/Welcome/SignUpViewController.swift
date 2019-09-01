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

    
    // MARK: - Signup
    func signUp() {
        // Validation actions for text fields
        let user = CurrentUser(first_name: firstName, last_name: lastName, email: email, password: password, tracks_id: track_id)
        
        
        
//        server.signUp(with: user) { (error) in
//            if let error = error  {
//                DispatchQueue.main.async {
//                    Config.showAlert(on: self, style: .alert, title: "Sign Up Error", message: error.localizedDescription)
//                }
//                return
//            } else {
//                // Save the encoded and decoded bearer tokens to user defaults
//                let defaults = UserDefaults.standard
//
//                defaults.set(self.server.encodedBearer, forKey: UserDefaultsKeys.encodedBearer)
//
//                DispatchQueue.main.async {
//                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    let vc = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
//                    self.present(vc, animated: true, completion: nil)
//                }
//            }
//
//        }
        
    }
    
    // MARK: - UI
    func updateViews() {
        registerButton.layer.masksToBounds = true
        registerButton.layer.cornerRadius = Config.buttonCornerRadius
    }
    
    
    // MARK: Validation Functions and Actions

    
    
    
    
}
