//
//  RequestPasswordResetViewController.swift
//  Career Endorsement Tracker
//
//  Created by Sameera Leola on 9/23/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class RequestPasswordResetViewController: UIViewController {
    
    // MARK: - Properties
    let server = Server()
    var emailAddress: String?
    
    // MARK: - Outlets
    @IBOutlet weak var emailAddressField: UITextField!
    
    
    // MARK: - View states
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Make sure we received an email address
        updateAfterEmail()
    }
    
    // MARK: - Actions
    @IBAction func requestPasswordTapped(_ sender: Any) {
    }
    
    
    @IBAction func cancelRequestTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Functions
    func updateAfterEmail() {
        guard let emailAddress = emailAddress  else { return }
        emailAddressField.text = emailAddress
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
