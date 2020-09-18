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
    
    // MARK: - Properties
    
    let server = Server()
    var users: [CurrentUser] = []
    @IBOutlet weak var imageView: UIImageView!
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchDetailSegue" {
            guard let destinationVC = segue.destination as? SearchDetailTableViewController, let indexPath = tableView.indexPathForSelectedRow else {
                print("no destination")
                return
            }
            print(users[indexPath.row].id)
            destinationVC.studentId = users[indexPath.row].id
        }
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
                    self.imageView.isHidden = true
                    self.tableView.separatorStyle = .singleLine
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CoachSearchCell") as? CoachSearchTableViewCell else {
            return UITableViewCell()
        }
        
        let user = users[indexPath.row]
        
        cell.currentIndexPath = indexPath
        cell.student = user
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension CoachSearchViewController: CoachSearchCellDelegate {
    func didPinStudent(cell: CoachSearchTableViewCell, indexPath: IndexPath, isPinned: Bool) {
        
        guard let token = UserDefaults.standard.object(forKey: "token") as? String else {
            return Config.showAlert(on: self, style: .alert, title: "User could not be authenticated.", message: "Please logout and sign in again.")
        }
        cell.pinStudentBtn.setTitle("Unpin", for: .normal)
        let student = users[indexPath.row]
        server.pinStudent(withToken: token, withStudentId: student.id) { (error) in
            if let error = error {
                DispatchQueue.main.async {
                    Config.showAlert(on: self, style: .alert, title: "Error", message: error.localizedDescription)
                    return
                }
            } else {
                DispatchQueue.main.async {
                    if isPinned {
                        Config.showAlert(on: self, style: .alert, title: "Success!", message: "\(student.first_name) \(student.last_name) has been assigned to you.")
                        
                        return
                    } else {
                        Config.showAlert(on: self, style: .alert, title: "Success!", message: "\(student.first_name) \(student.last_name) has been unassigned.")
                        return
                    }
                }
            }
        }
    }
    
    
}
