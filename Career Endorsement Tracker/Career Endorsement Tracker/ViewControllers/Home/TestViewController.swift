//
//  TestViewController.swift
//  Career Endorsement Tracker
//
//  Created by Victor  on 9/10/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import UIKit

class TestViewController: UIViewController {
    
    @IBOutlet weak var welcomeView: UIView!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        self.welcomeView.layer.shadowPath =
            UIBezierPath(roundedRect: self.welcomeView.bounds,
                         cornerRadius: self.welcomeView.layer.cornerRadius).cgPath
        self.welcomeView.layer.shadowColor = UIColor.black.cgColor
        self.welcomeView.layer.shadowOpacity = 0.5
        self.welcomeView.layer.shadowOffset = CGSize(width: 10, height: 10)
        self.welcomeView.layer.shadowRadius = 1
        self.welcomeView.layer.masksToBounds = false
    }
    
}


