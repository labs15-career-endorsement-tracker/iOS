//
//  HomeDetailTableViewController.swift
//  Career Endorsement Tracker
//
//  Created by Victor  on 9/5/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import UIKit
import JGProgressHUD

class HomeDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var requirementProgessView: UIProgressView!
    
    var server: Server?
    var id: Int?
    var steps: [Step] = []
    var requirement: Requirement?
    
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hud.textLabel.text = "Loading Requirements..."
        hud.show(in: view, animated: true)
        fetchStepsFromServer()
        updateViews()
        NotificationCenter.default.addObserver(self, selector: #selector(submitButtonPressed(notificaiton:)), name: .didSubmit, object: nil)
    }
    
    @objc func submitButtonPressed(notificaiton: Notification) {
        //handles logic for submit button pressed
        fetchStepsFromServer()
        fetchSingleRequirementFromServer()
        updateViews()
    }
    
    func fetchSingleRequirementFromServer() {
        let token = UserDefaults.standard.object(forKey: "token") as! String
        guard let server = server else {
            print("no server")
            return
        }
        guard let id = id else {
            print("no id")
            return
        }
        server.fetchRequirements(withId: token) { (RequirementsResult, error) in
            if let error = error {
                DispatchQueue.main.async {
                    self.hud.dismiss(animated: true)
                    Config.showAlert(on: self, style: .alert, title: "Fetching Error", message: error.localizedDescription)
                }
                return
            }
            if let requirementsResult = RequirementsResult {
                let array = requirementsResult.filter { $0.id == id }
                let requirement = array[0]
                let progress = Float(requirement.progress)
                let finalProgress = progress / 100
                DispatchQueue.main.async {
                    self.requirementProgessView.setProgress(finalProgress, animated: true)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func updateViews() {
        guard let requirement = requirement else {
            print("no requirement")
            return
        }
        title = requirement.title
        let progress = Float(requirement.progress)
        let finalProgress = progress / 100
        requirementProgessView.setProgress(finalProgress, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return steps.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StepCell", for: indexPath) as? HomeDetailTableViewCell else {
            return UITableViewCell()
        }
    
        let step = steps[indexPath.row]
        cell.server = server
        cell.step = step
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 144
    }
    
    
    func fetchStepsFromServer() {
        let token = UserDefaults.standard.object(forKey: "token") as! String
        guard let server = server else {
            print("no server")
            return
        }
        guard let id = id else {
            print("no id")
            return
        }
        server.fetchSteps(withId: token, withReqId: id) { (stepsResult, error) in
            if let error = error {
                print(error)
                DispatchQueue.main.async {
                    self.hud.dismiss(animated: true)
                    Config.showAlert(on: self, style: .alert, title: "Fetching Error", message: error.localizedDescription)
                }
                return
            }
            
            if let stepsResult = stepsResult {
                self.steps = stepsResult
                DispatchQueue.main.async {
                    self.hud.dismiss(animated: true)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
}
