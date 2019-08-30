//
//  CareerEndorsementViewController.swift
//  Career Endorsement Tracker
//
//  Created by Sameera Roussi on 8/15/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class CareerEndorsementViewController: UIViewController {
    
    // MARK: - Properties

    // MARK: - Outlets
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var sayHelloButton: UIButton!
    
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    // MARK: - Actions
    @IBAction func sayHelloButtonTapped(_ sender: Any) {
        greetingLabel.text = "Greetings from the Labs15\nCareer Endorsement Team!"
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
