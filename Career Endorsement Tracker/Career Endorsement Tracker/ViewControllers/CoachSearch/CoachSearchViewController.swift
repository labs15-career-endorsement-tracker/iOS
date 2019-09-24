//
//  CoachSearchViewController.swift
//  Career Endorsement Tracker
//
//  Created by Victor  on 9/19/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import UIKit

class CoachSearchViewController: UIViewController {
    
    let server = Server()
    var users: [CurrentUser] = []
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

extension CoachSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            Config.showAlert(on: self, style: .alert, title: "Search Error", message: "Please enter valid name to search")
            return
        }
        
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("no token")
            return
        }
        
        server.searchUser(withId: token, withName: searchText) { (users, error) in
            if let error = error {
                DispatchQueue.main.async {
                    Config.showAlert(on: self, style: .alert, title: "Search Error", message: error.localizedDescription)
                }
                return
            }
            
            if let users = users {
                self.users = users
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
}

extension CoachSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CoachSearchCell") else {
            return UITableViewCell()
        }
        
        let user = users[indexPath.row]
        cell.textLabel?.text = "\(user.first_name) \(user.last_name)"
        
        return cell
    }
}
