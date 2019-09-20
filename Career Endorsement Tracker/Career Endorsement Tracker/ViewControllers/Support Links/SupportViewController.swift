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
    
    var supportLinks = ["https://twitter.com/getendrsd", "mailto:\(Defaults.email)", ""]
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SupportViewController: UITableViewDelegate {
    
}

extension SupportViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return supportLinks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("SupportTableViewCell", owner: self, options: nil)?.first as! SupportTableViewCell
        
        return cell
    }
    
    
}
