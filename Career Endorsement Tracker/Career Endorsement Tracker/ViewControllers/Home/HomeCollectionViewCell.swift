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
    
    // MARK: - Outlets
    
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    // MARK: - Properties
    
    var requirement: Requirement? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Methods
    
    func updateViews() {
        guard let requirement = requirement else {
            print("no requiremetn")
            return}
        print(requirement.title)
        taskNameLabel.text = requirement.title
        let progress = Float(requirement.progress)
        let finalProgress = progress / 100
        print("last line")
        progressView.setProgress(finalProgress, animated: true)
        print("error line")
    }
}
