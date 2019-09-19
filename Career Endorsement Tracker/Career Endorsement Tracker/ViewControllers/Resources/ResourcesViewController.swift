//
//  ResourcesViewController.swift
//  Career Endorsement Tracker
//
//  Created by Alex on 9/17/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class ResourcesViewController: UIViewController {

    // MARK: - Properties
    
    var requirement: Requirement? {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }

}

extension ResourcesViewController: UITableViewDelegate {
    
}

extension ResourcesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("HERE in TV VC: ", requirement?.resources.count, requirement?.resources.first?.url)
        return requirement?.resources.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("ResourcesTableViewCell", owner: self, options: nil)?.first as! ResourcesTableViewCell

        cell.resource = requirement?.resources[indexPath.row]
        print("HERE resource req: ", requirement?.resources[indexPath.row].url)
        return cell
    }
    
    
}
