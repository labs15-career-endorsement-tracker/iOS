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
    
    var server: Server?
    var id: Int?
    
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hud.textLabel.text = "Loading Requirements..."
        hud.show(in: view, animated: true)
        guard let id = id else {
            print("No id")
            return
        }
        fetchStepsFromServer()
        print(id)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let server = server else {
            print("no server")
            return 0
        }
        return server.steps.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StepCell", for: indexPath) as? HomeDetailTableViewCell else {
            return UITableViewCell()
        }
        guard let server = server else {
            print("No server")
            return cell
        }
        
        let step = server.steps[indexPath.row]
        cell.step = step
        
        return cell
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
        server.fetchSteps(withId: token, withReqId: id) { (error) in
            if let error = error {
                print(error)
                self.hud.dismiss(animated: true)
                Config.showAlert(on: self, style: .alert, title: "Fetching Error", message: error.localizedDescription)
                return
            }
            print("Fucking success bitches")
            DispatchQueue.main.async {
                self.hud.dismiss(animated: true)
                self.tableView.reloadData()
            }
        }
    }
    
}
