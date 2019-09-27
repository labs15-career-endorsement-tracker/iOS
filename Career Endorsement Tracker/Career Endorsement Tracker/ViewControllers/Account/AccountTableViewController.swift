//
//  AccountTableViewController.swift
//  Career Endorsement Tracker
//
//  Created by Alex on 9/20/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class AccountTableViewController: UITableViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var trackLbl: UILabel!
    @IBOutlet weak var coachNameLabel: UILabel!
    @IBOutlet weak var calendlyLinkButton: UIButton!
    
    var calendlyLink: String?
    var coach: Coach?
    var url: URL?
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let user = CoreUser.user else {return}
        nameLbl.text = user.first_name + " " + user.last_name
        emailLbl.text = user.email
        trackLbl.text = user.tracks_title
        updateViews()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? CGFloat.leastNormalMagnitude : tableView.sectionHeaderHeight
    }
    
    // Mark: - Actions
    
    @IBAction func logoutBtnPressed(_ sender: UIBarButtonItem) {
        let signOutAction = UIAlertAction(title: "Sign Out", style: .destructive) {
            (action) in
            UserDefaults.standard.removeObject(forKey: "token")
            UserDefaults.standard.removeObject(forKey: "id")
            UserDefaults.standard.removeObject(forKey: "firstName")
            UserDefaults.standard.removeObject(forKey: "isAdmin")
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            let storyboard = UIStoryboard(name: "Welcome", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "WelcomeNavigationController")
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        Config.showAlert(on: self, style: .actionSheet, title: nil, message: nil, actions: [signOutAction, cancelAction], completion: nil)
    }
    
    //MARK: Helper
    
    func updateViews() {
        if let coach = coach {
            coachNameLabel.text = "Coach: \(coach.first_name) \(coach.last_name)"
        }
        if let calendlyLink = calendlyLink, let url = URL(string: calendlyLink) {
            calendlyLinkButton.setTitle(calendlyLink, for: .normal)
            self.url = url
        }
    }
    
    @IBAction func calendlyLinkButtonPressed(_ sender: Any) {
        if let coachLink = url, UIApplication.shared.canOpenURL(coachLink) {
            UIApplication.shared.open(coachLink)
        } else {
            Config.showAlert(on: self, style: .alert, title: "No Link", message: "Sorry, please wait until you have been assigned a career coach. ")
            return
        }
    }
}
