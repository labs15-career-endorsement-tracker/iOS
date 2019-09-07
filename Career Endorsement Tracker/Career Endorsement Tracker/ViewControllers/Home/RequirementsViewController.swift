//
//  RequirementsViewController.swift
//  Career Endorsement Tracker
//
//  Created by Victor  on 9/6/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import UIKit
import JGProgressHUD

class RequirementsViewController: UIViewController {
    
    // MARK: - Instances
    let server = Server()
    var requirements: [Requirement] = []
    var currentUser: CurrentUser?
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var overallProgressLabel: UILabel!
    
    //displays progress sign
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        hud.textLabel.text = "Loading Requirements..."
        hud.show(in: view, animated: true)
        collectionView.delegate = self
        collectionView.dataSource = self
        fetchRequirementsFromServer()
        print(requirements)
    }
    
    func updateViews() {
        let logo = UIImage(named: "logo")!
        let imageView = UIImageView(image: logo)
        self.navigationItem.titleView = imageView
        guard let name = UserDefaults.standard.value(forKey: "firstName") as? String else {
            return
        }
        userNameLabel.text = name
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchRequirementsFromServer()
        fetchUser()
    }

    func fetchRequirementsFromServer() {
        guard let token = UserDefaults.standard.object(forKey: "token") as? String else {
            return
        }
        server.fetchRequirements(withId: token) { (reqResult, error) in
            if let error = error {
                print(error)
                DispatchQueue.main.async {
                    self.hud.dismiss(animated: true)
                    Config.showAlert(on: self, style: .alert, title: "Fetching Error", message: error.localizedDescription)
                }
                return
            }
            if let reqResult = reqResult {
                self.requirements = reqResult
                print(self.requirements)
                DispatchQueue.main.async {
                    self.hud.dismiss(animated: true)
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func fetchUser() {
        guard let token = UserDefaults.standard.object(forKey: "token") as? String else {
            return
        }
        guard let id = UserDefaults.standard.object(forKey: "id") as? Int else {
            return
        }
        server.fetchUser(withId: token, withUserId: id) { (CurrentUser, error) in
            if let error = error {
                print(error)
                DispatchQueue.main.async {
                    self.hud.dismiss(animated: true)
                    Config.showAlert(on: self, style: .alert, title: "Fetching Error", message: error.localizedDescription)
                }
                return
            }
            if let currentUser = CurrentUser {
                self.currentUser = currentUser
                DispatchQueue.main.async {
                    self.hud.dismiss(animated: true)
                    self.overallProgressLabel.text = "\(currentUser.progress)%"
                    if self.userNameLabel.text == "Welcome, " {
                        self.userNameLabel.text = "Welcome, \(currentUser.first_name)"
                    }
                }
            }

        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSegue" {
            guard let destinationVC = segue.destination as? HomeDetailTableViewController else {
                print("NO destination")
                return
            }
            guard let indexPath = collectionView.indexPathsForSelectedItems?.first else {
                return
            }
            destinationVC.server = server
            destinationVC.id = requirements[indexPath.item].id
            destinationVC.requirement = requirements[indexPath.item]
        }
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        let signOutAction = UIAlertAction(title: "Sign Out", style: .destructive) {
            (action) in
            UserDefaults.standard.set(nil, forKey: "token")
            UserDefaults.standard.set(nil, forKey: "id")
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            let storyboard = UIStoryboard(name: "Welcome", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "WelcomeNavigationController")
            self.present(vc, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        Config.showAlert(on: self, style: .actionSheet, title: nil, message: nil, actions: [signOutAction, cancelAction], completion: nil)
    }
}

extension RequirementsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return requirements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReqCell", for: indexPath) as! HomeCollectionViewCell
        print("updating cell")
        let requirement = requirements[indexPath.item]
        print(requirement)
        cell.requirement = requirement
        return cell
    }
}
