//
//  AccountTableViewController.swift
//  Career Endorsement Tracker
//
//  Created by Alex on 9/20/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class AccountTableViewController: UITableViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var trackLbl: UILabel!
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let user = CoreUser.user else {return}
        nameLbl.text = user.first_name + " " + user.last_name
        emailLbl.text = user.email
        trackLbl.text = user.tracks_title
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? CGFloat.leastNormalMagnitude : tableView.sectionHeaderHeight
    }
}
