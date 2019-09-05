//
//  HomeDetailTableViewCell.swift
//  Career Endorsement Tracker
//
//  Created by Victor  on 9/5/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import UIKit


class HomeDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var stepLabel: UILabel!
    
    var step: Step? {
        didSet {
            updateViews()
        }
    }
    
    private func updateViews() {
        guard let step = step else {
            print("No step")
            return
        }
        stepLabel.text = step.steps_description
    }
}
