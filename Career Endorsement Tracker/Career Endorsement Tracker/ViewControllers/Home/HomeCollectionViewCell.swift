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
    @IBOutlet weak var progressView: UIProgressView!
    
    var requirement: Requirement? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard let requirement = requirement else {return}
        taskNameLabel.text = requirement.title
        let progress = Float(requirement.progress)
        let finalProgress = progress / 100
        progressView.setProgress(finalProgress, animated: true)
    }
}
