//
//  CoachCalendlyViewController.swift
//  Career Endorsement Tracker
//
//  Created by Alex on 9/24/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class CoachCalendlyViewController: UIViewController {
    
    let server = Server()
    
    @IBOutlet weak var addCalendlyButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var calendlyLinkButton: UIButton!
    var coachLink: URL?
    var coach: CurrentUser?

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserFromServer()
    }
    
    @IBAction func addCalendlyButtonPressed(_ sender: Any) {
        guard let link = textField.text, !link.isEmpty else {
            Config.showAlert(on: self, style: .alert, title: "Invalid URL", message: "Please enter a valid URL.")
            return
        }
        
        guard let url = URL(string: link) else {
            Config.showAlert(on: self, style: .alert, title: "Invalid URL", message: "Please enter a valid URL.")
            return
        }
        
        guard let token = UserDefaults.standard.object(forKey: "token") as? String else {
                   return Config.showAlert(on: self, style: .alert, title: "User could not be authenticated.", message: "Please logout and sign in again.")
               }
        
               
        print("hello")
        server.addCalendlyLink(withToken: token, withLink: link) { (error) in
            if let error = error {
                DispatchQueue.main.async {
                    Config.showAlert(on: self, style: .alert, title: "Error Adding Link", message: error.localizedDescription)
                }
                return
            }
            self.coachLink = url
            print(url)
            DispatchQueue.main.async {
                self.calendlyLinkButton.setTitle(link, for: .normal)
                Config.showAlert(on: self, style: .alert, title: "Success", message: "Calendly Link Added!")
            }
        }
        
    }
    
    @IBAction func calendlyLinkButton(_ sender: Any) {
        
        if let coachLink = coachLink, UIApplication.shared.canOpenURL(coachLink) {
            UIApplication.shared.open(coachLink)
        } else {
            Config.showAlert(on: self, style: .alert, title: "No Link", message: "Please provide valid calendly link.")
            return
        }
    }
    
    func fetchUserFromServer() {
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("no token")
            return
        }
        guard let id = UserDefaults.standard.object(forKey: "id") as? Int else {
            return
        }
        server.fetchUser(withId: token, withUserId: id) { (CurrentUser, error) in
            if let error = error {
                DispatchQueue.main.async {
                    Config.showAlert(on: self, style: .alert, title: "Error Fetching User", message: error.localizedDescription)
                }
                return
            }
            if let currentUser = CurrentUser {
                self.coach = currentUser
                if let link = currentUser.calendly_link, let url = URL(string: link) {
                    self.coachLink = url
                    DispatchQueue.main.async {
                        self.calendlyLinkButton.setTitle(link, for: .normal)
                    }
                } else {
                    DispatchQueue.main.async {
                        Config.showAlert(on: self, style: .alert, title: "URL Error", message: "No Valid URL Found.")
                    }
                    return
                }
            }
            
        }
    }

}
