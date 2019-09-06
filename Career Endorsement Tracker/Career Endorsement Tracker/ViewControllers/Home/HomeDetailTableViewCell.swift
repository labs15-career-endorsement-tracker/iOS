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
    @IBOutlet weak var submitCompletionButton: UIButton!
    @IBOutlet weak var stepTextView: UITextView!
    
    var server: Server?
    var step: Step? {
        didSet {
            updateViews()
        }
    }
    let completedImage = UIImage(named: "checkBox")
    let incompleteImage = UIImage(named: "uncheckedBox")
    
    private func updateViews() {
        guard let step = step else {
            print("No step")
            return
        }
        stepTextView.text = step.steps_description
        if step.is_complete {
//            submitCompletionButton.backgroundColor = .green
            submitCompletionButton.setImage(completedImage, for: .normal)
//            submitCompletionButton.setImage("checkedBox, for: .normal)
//            submitCompletionButton.setTitle("Completed", for: .normal)
        } else {
//            submitCompletionButton.backgroundColor = .red
//            submitCompletionButton.setTitle("Not Completed", for: .normal)
            submitCompletionButton.setImage(incompleteImage, for: .normal)
        }
    }
    
    @IBAction func submitCompletionButtonPressed(_ sender: UIButton) {
        
        guard let step = step else {
            print("no step")
            return
        }
        
        let isCompleted = step.is_complete
        
        guard let server = server else {
            print("no server")
            return
        }
        let token = UserDefaults.standard.object(forKey: "token") as! String
        server.updateStep(withId: token, withReqId: step.tasks_id, withStepId: step.id, isComplete: isCompleted) { (error) in
            if let error = error {
                print(error)
                return
            }
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .didSubmit, object: Any?.self)

            }
        }
    }
    
}
