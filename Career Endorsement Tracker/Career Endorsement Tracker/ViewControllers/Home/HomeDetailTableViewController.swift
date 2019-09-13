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
import UICircularProgressRing

extension Notification.Name {
    static let didSubmit = Notification.Name("didSubmit")
}

class HomeDetailTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var server: Server?
    var id: Int?
    var steps: [Step] = []
    var requirement: Requirement?
    
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()
    
    // MARK: - Outlets
    
    @IBOutlet weak var requirementProgessView: UICircularProgressRing!
    @IBOutlet weak var progressLabel: UILabel!
    
    // MARK: - Actions
    
    @objc func submitButtonPressed(notificaiton: Notification) {
        //handles logic for submit button pressed
        fetchStepsFromServer()
        fetchSingleRequirementFromServer()
        updateViews()
    }
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "StepCell", bundle: nil), forCellReuseIdentifier: StepCell.reuseId)
        
        hud.textLabel.text = "Loading Requirements..."
        hud.show(in: view, animated: true)
        fetchStepsFromServer()
        updateViews()
        NotificationCenter.default.addObserver(self, selector: #selector(submitButtonPressed(notificaiton:)), name: .didSubmit, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.reloadData()
    }

    // MARK: - Fetch
    
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
                    self.updateProgress(progress: requirement.progress)
                    self.progressLabel.text = "\(requirement.progress)%"
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
        self.updateProgress(progress: requirement.progress)
        requirementProgessView.maxValue = 100
        requirementProgessView.style = .dashed(pattern: [1.0, 1.0])
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
    
    private func updateProgress(progress: Int){
        //        progressBar.labelSize = 20
        //        progressBar.safePercent = 10
        //        progressBar.setProgress(to: 10.0, withAnimation: false)
        //        progressBar.animate(toAngle: 90, duration: 2.5, completion: nil)
        
        //        progressBar.trackClr = UIColor.cyan
        //        progressBar.progressClr = UIColor.purple
        //        progressBar.setProgressWithAnimation(duration: 1.0, value: 0.60)
        
        requirementProgessView.startProgress(to: CGFloat(progress), duration: 2.0) {
            print("Done animating!")
        }
    }

    
}

extension HomeDetailTableViewController {

    // MARK: - Tableview
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return steps.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StepTableViewCell", for: indexPath) as? StepCell else {
            return UITableViewCell()
        }
        
        let step = steps[indexPath.row]
        
        cell.backgroundColor = UIColor(red: 251/255, green: 254/255, blue: 255/255, alpha: 1)
        cell.step = step
        cell.indexPath = indexPath
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension HomeDetailTableViewController: StepCellDelegate {
    func didSelect(_ cell: StepCell, atIndexPath indexPath: IndexPath) {
        let step = steps[indexPath.row]
        
        let isCompleted = step.is_complete
        
        guard let server = server else {
            print("no server")
            return
        }
        
        let token = UserDefaults.standard.object(forKey: "token") as! String
        
        server.updateStep(withId: token, withReqId: step.tasks_id, withStepId: step.id, isComplete: isCompleted) { (error) in
            if let error = error {
                print(error)
                return
            }
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .didSubmit, object: Any?.self)
            }
        }
    }
}
