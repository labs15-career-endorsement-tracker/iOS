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
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
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
                print(users)
            }
        }
        
    }
    
}
