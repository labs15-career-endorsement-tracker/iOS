//
//  CoachProfileTableViewController.swift
//  Career Endorsement Tracker
//
//  Created by Alex on 9/24/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import JGProgressHUD

class CoachProfileTableViewController: UITableViewController {
    
    //MARK: - Properties
    
    let server = Server()
    var students: [CurrentUser] = []
    
    //displays progress sign
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        hud.textLabel.text = "Loading Assigned Students..."
        hud.show(in: view, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchPinnedStudents()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return students.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CoachProfileCell", for: indexPath) as? CoachProfileTableViewCell else {
            return UITableViewCell()
        }
        let student = students[indexPath.row]
        cell.student = student
        return cell
    }
    
    //MARK: Networking
    
    func fetchPinnedStudents() {
        
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("no token")
            return
        }
        
        server.fetchPinnedStudents(withToken: token) { (result, error) in
            
            if let error = error {
                DispatchQueue.main.async {
                    self.hud.dismiss(animated: true)
                    Config.showAlert(on: self, style: .alert, title: "Error fetching pinned students", message: error.localizedDescription)
                    return
                }
            }
            if let pinnedStudents = result {
                self.students = pinnedStudents
                DispatchQueue.main.async {
                    self.hud.dismiss(animated: true)
                    self.tableView.reloadData()
                }
            }
            
        }
    
    }
    
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
            self.present(vc, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        Config.showAlert(on: self, style: .actionSheet, title: nil, message: nil, actions: [signOutAction, cancelAction], completion: nil)
    }
}
