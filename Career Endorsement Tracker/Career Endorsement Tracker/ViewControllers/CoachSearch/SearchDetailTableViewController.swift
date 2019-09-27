//
//  SearchDetailTableViewController.swift
//  Career Endorsement Tracker
//
//  Created by Victor  on 9/24/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import UICircularProgressRing

class SearchDetailTableViewController: UITableViewController {

    // MARK: - Properties
    
    var studentId: Int?
    let server = Server()
    var student: CurrentUser?
    var requirements: [Requirement] = []
    
    // MARK: - Outlets
    
    @IBOutlet weak var progressBar: UICircularProgressRing!
    @IBOutlet weak var progressLabel: UILabel!
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
        fetchRequirements()
        updateViews()
    }
    
    // MARK: - Setup UI
    
    func updateViews() {
        guard let student = student else {
            return
        }
        title = student.first_name + " " + student.last_name
        
        progressBar.maxValue = 100
        progressBar.style = .dashed(pattern: [1.0, 1.0])
        progressBar.innerRingColor = Config.lightGreenDesignColor
        progressBar.startAngle = CGFloat(-90)
        progressBar.endAngle = CGFloat(270)
        progressBar.fontColor = .white
    }
    
    private func updateProgress(progress: Int) {
        progressBar.startProgress(to: CGFloat(progress), duration: 2.0) {
            print("Done animating!")
        }
    }
    
    // MARK: - TableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requirements.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath)
        
        // Get the student
        let requirement = requirements[indexPath.row]
        
        cell.textLabel?.text = requirement.title
        cell.detailTextLabel?.text = "\(requirement.progress)%"
        
        return cell
    }
    
    // MARK: - Fetch
    
    func fetchRequirements() {
        guard let token = UserDefaults.standard.string(forKey: "token") else {return print("no token")}
        guard let studentId = studentId else {return print("no id")}
        
        server.fetchUserRequirements(withToken: token, userID: studentId) { (requirements, error) in
            if let error = error {
                DispatchQueue.main.async {
                    Config.showAlert(on: self, style: .alert, title: "Error fetching requirements", message: error.localizedDescription)
                    return
                }
            }
            
            if let requirements = requirements {
                self.requirements = requirements
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    func fetchUser() {
        guard let token = UserDefaults.standard.string(forKey: "token") else {return print("no token")}
        guard let studentId = studentId else {return print("no id")}
        
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
//                    self.progressLabel.text = "\(studentObj.progress ?? 0)%"
                    self.updateProgress(progress: studentObj.progress ?? 0)
                    self.updateViews()
                    self.tableView.reloadData()
                }
            }
        }
    }
    
}
