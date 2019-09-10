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

extension Notification.Name {
    static let didSubmit = Notification.Name("didSubmit")
}

class HomeDetailTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    let emitt = Emitter()
    var server: Server?
    var id: Int?
    var steps: [Step] = []
    var requirement: Requirement?
    var refreshView: BreakOutToRefreshView!
    
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()
    
    // MARK: - Outlets
    
    @IBOutlet weak var requirementProgessView: UIProgressView!
    
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
        hud.textLabel.text = "Loading Requirements..."
        hud.show(in: view, animated: true)
        fetchStepsFromServer()
        updateViews()
        NotificationCenter.default.addObserver(self, selector: #selector(submitButtonPressed(notificaiton:)), name: .didSubmit, object: nil)
        startConfetti()
        setupRefresh()
    }
    
    // MARK: - Methods
    
    private func startConfetti(){
        emitt.emitter.emitterShape = CAEmitterLayerEmitterShape.line
        emitt.emitter.emitterCells = generateEmitterCells()
        emitt.emitter.emitterPosition = CGPoint(x: self.view.frame.size.width / 2, y: -10)
        emitt.emitter.emitterSize = CGSize(width: self.view.frame.size.width, height: 2.0)
        self.view.layer.addSublayer(emitt.emitter)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            self.emitt.endParticles()
        }
    }
    
    private func setupRefresh(){
        refreshView = BreakOutToRefreshView(scrollView: tableView)
        refreshView.refreshDelegate = self
        
        // configure the refresh view
        refreshView.scenebackgroundColor = .white
        refreshView.textColor = .black
        refreshView.paddleColor = .brown
        refreshView.ballColor = .darkGray
        refreshView.blockColors = [.blue, .green, .red]
        
        tableView.addSubview(refreshView)
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
                if finalProgress == 1 {self.fullProgress()}
                DispatchQueue.main.async {
                    self.requirementProgessView.setProgress(finalProgress, animated: true)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    private func fullProgress(){
        print("User has completed requirements")
        //startConfetti()
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

extension HomeDetailTableViewController {

    // MARK: - Tableview
    
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
}

extension HomeDetailTableViewController {
    
    // MARK: - ScrollView
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        refreshView.scrollViewDidScroll(scrollView)
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        refreshView.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        refreshView.scrollViewWillBeginDragging(scrollView)
    }
}

extension HomeDetailTableViewController: BreakOutToRefreshDelegate {
    
    func refreshViewDidRefresh(_ refreshView: BreakOutToRefreshView) {
        // load stuff from the internet
        print("Refreshed table view")
    }
}
