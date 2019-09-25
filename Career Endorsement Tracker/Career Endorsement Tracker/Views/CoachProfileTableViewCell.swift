//
//  CoachProfileTableViewCell.swift
//  Career Endorsement Tracker
//
//  Created by Victor  on 9/24/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import UIKit

class CoachProfileTableViewCell: UITableViewCell {
    @IBOutlet weak var studentNameLabel: UILabel!
    
    var student: CurrentUser? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard let student = student else {
            print("no student")
            return
        }
        
        studentNameLabel.text = student.first_name + " " + student.last_name
    }
}
