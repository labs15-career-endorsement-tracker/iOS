//
//  SupportTableViewController.swift
//  Career Endorsement Tracker
//
//  Created by Alex on 9/21/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class SupportTableViewController: UITableViewController {
    
    // MARK: - Defaults
    
    struct Defaults {
        static let email = "support@endrsd.com"
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var slackTextView: UITextView!
    @IBOutlet weak var twitterTextView: UITextView!
    @IBOutlet weak var emailTextView: UITextView!
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Setup
    
    private func updateViews(){
        // Slack Text View
        let attributedString = NSAttributedString.hyperLink(originalText: "Slack", hyperLink: "Slack", urlString: "https://app.slack.com/client/T4JUEB3ME/CN99JD9J5")
        slackTextView.attributedText = attributedString
        slackTextView.sizeToFit()
        slackTextView.tintColor = #colorLiteral(red: 0.1607843137, green: 0.6745098039, blue: 0.2666666667, alpha: 1)
        
        // Twitter Text View
        let attributedString2 = NSAttributedString.hyperLink(originalText: "Twitter", hyperLink: "Twitter", urlString: "https://twitter.com/getendrsd")
        twitterTextView.attributedText = attributedString2
        twitterTextView.sizeToFit()
        twitterTextView.tintColor = #colorLiteral(red: 0.1607843137, green: 0.6745098039, blue: 0.2666666667, alpha: 1)
        
        // Email Text View
        let attributedString3 = NSAttributedString.hyperLink(originalText: "Email", hyperLink: "Email", urlString: "mailto:\(Defaults.email)")
        emailTextView.attributedText = attributedString3
        emailTextView.sizeToFit()
        emailTextView.tintColor = #colorLiteral(red: 0.1607843137, green: 0.6745098039, blue: 0.2666666667, alpha: 1)
    }
}
