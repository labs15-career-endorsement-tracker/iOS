//
//  SearchDetailTableViewController.swift
//  Career Endorsement Tracker
//
//  Created by Victor  on 9/24/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import UIKit

class SearchDetailTableViewController: UITableViewController {

    var studentId: Int?
    let server = Server()
    var student: CurrentUser?
    @IBOutlet weak var progressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
        updateViews()
    }
    
    func updateViews() {
        guard let student = student else {
            return
        }
        title = student.first_name + " " + student.last_name
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func fetchUser() {
        
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("no token")
            return
        }
        
        guard let studentId = studentId else {
            print("no id")
            return
        }
        
        server.fetchUser(withId: token, withUserId: studentId) { (student, error) in
            if let error = error {
                DispatchQueue.main.async {
                    Config.showAlert(on: self, style: .alert, title: "Error fetching student", message: error.localizedDescription)
                    return
                }
            }
            if let studentObj = student {
                self.student = studentObj
                DispatchQueue.main.async {
                    self.progressLabel.text = "\(String(describing: studentObj.progress))%"
                    self.tableView.reloadData()
                }
            }
        }
        
    }
}
