//
//  SupportViewController.swift
//  Career Endorsement Tracker
//
//  Created by Alex on 9/19/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class SupportViewController: UIViewController {

    struct Defaults {
        static let email = "support@endrsd.com"
    }
    // MARK: - Properties
    
    var supportLinks = ["https://twitter.com/getendrsd", "mailto:\(Defaults.email)", "https://app.slack.com/client/T4JUEB3ME/CN99JD9J5"]
    var supportIcons = [UIImage(), UIImage(), UIImage()]
    
    // MARK: - Outlets
    
    @IBOutlet weak var supportLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension SupportViewController: UITableViewDelegate {
    
}

extension SupportViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return supportLinks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("SupportTableViewCell", owner: self, options: nil)?.first as! SupportTableViewCell
        
        cell.url = supportLinks[indexPath.row]
        cell.iconImage = supportIcons[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
