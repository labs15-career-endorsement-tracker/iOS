//
//  HomeCollectionViewCell.swift
//  Career Endorsement Tracker
//
//  Created by Victor  on 8/27/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var taskDescription: UILabel!
    
    var task: Task? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard let task = task else {return}
        taskNameLabel.text = task.name
        taskDescription.text = task.description
    }
}
